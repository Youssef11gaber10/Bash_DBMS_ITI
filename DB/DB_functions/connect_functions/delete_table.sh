#!/usr/bin/env bash

source ./DB/DB_functions/connect_functions/condition_check.sh

function delete_table()
{
 
    #Validation
    #is DB selected
    if [[ -z "$DB_Dir/$Curr_DB" ]];then
        echo -e "${RED}No database selected. please connect first.${RESET}"
        return
    fi

    list_tables
    echo -e "${YELLOW}${BOLD}Enter the name of the table you want to delete from : ${RESET}"
    read table
    #does table exist
    if [[ ! -d "$DB_Dir/$Curr_DB/$table" ]];then
        echo -e "${RED}Table doesn't exist.${RESET}"
        return
    fi

    #does meta and date files exist
    meta_file="$DB_Dir/$Curr_DB/$table/$table.meta"
    data_file="$DB_Dir/$Curr_DB/$table/$table.data"
    if [[ ! -f "$meta_file" || ! -f "$data_file" ]]; then
        echo -e "${RED}Meta file or Date file doesn't exist.${RESET}"
        return
    fi    

    # read meta file
    col_names=()
    col_types=()

    while IFS=':' read -r cname coltype ckey; do
        col_names+=("$cname")
        col_types+=("$coltype")
    done < "$meta_file"

    # where
    echo -e "${YELLOW}${BOLD}WHERE  ${RESET}"
    read where_col 

    where_index=-1
    for i in "${!col_names[@]}";do
        if [[ "${col_names[$i]}" == "$where_col" ]];then
            where_index=$i
            break
        fi
    done


    if [[ $where_index -eq -1 ]];then
        echo -e "${RED}Column $where_col doesnt exist.${RESET}" 
        return 1   
    fi

    # operator
    echo -e "${YELLOW}${BOLD}Operator ${UNDERLINE}[ = != > < ] ) ${RESET}" 
    read op

    #where value
    echo -e "${YELLOW}${BOLD}where value=  ${RESET}" 
    read where_val
    where_val=$(echo "$where_val" | tr -d '[:space:]')


    #actually delete 
    # tmp file
    tmp_file="$DB_Dir/$Curr_DB/$table/temp_file"
    > "$tmp_file"
    deleted=false

    temp_delimiter=$'\037'
    while IFS="$temp_delimiter" read -r -a row; do
    
        if [[ "${#row[@]}" -ne "${#col_names[@]}" ]];then
            continue
        fi

        if condition "${row[$where_index]}" "$op" "$where_val";then
            deleted=true
            continue
        fi

       ( IFS=$''; echo "${row[*]/%/<|>}" | sed 's/<|>$//' ) >> "$tmp_file"

    done < <(sed "s/<|>/$temp_delimiter/g" "$data_file")

    if [[ "$deleted" == false ]]; then
        echo -e "${RED}No matching records${RESET}"
        rm -f "$tmp_file"
        return 1
    fi

    mv "$tmp_file" "$data_file"
    echo -e "${GREEN}${BOLD}Record deleted successfully.${RESET}"

}

