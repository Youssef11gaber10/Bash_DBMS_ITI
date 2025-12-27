#!/usr/bin/env bash

function update_table()
{
    #Validation
    #is DB selected
    if [[ -z "$DB_Dir/$Curr_DB" ]];then
        echo -e "${RED}No database selected. please connect first.${RESET}"
        return
    fi

    list_tables
    echo -e "${YELLOW}${BOLD}Enter the name of the table you want to update : ${RESET}"
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
    declare -a col_names
    declare -a col_types
    pk_index=-1

    index=0
    while IFS='|' read -r cname coltype ckey; do
        col_names+=("$cname")
        col_types+=("$coltype")
        if [[ "$ckey" == "PK" ]];then
            pk_index=$index
        fi
        ((index++))
    done < "$meta_file"


    if [[ $pk_index -eq -1 ]];then
        echo -e "${RED}PK is not found.${RESET}" 
        return 1   
    fi

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

    #where value
    echo -e "${YELLOW}${BOLD}= ${RESET}" 
    read where_val
    where_val=$(echo "$where_val" | tr -d '[:space:]')


    #set
    declare -a updates

    while true;do
        echo -e "${YELLOW}${BOLD}SET ${RED}${BOLD}(done to exit): ${RESET}"
        read col_name

        if [[ "$col_name" == "done" ]];then
            break
        fi

        update_index=-1
        for i in "${!col_names[@]}";do
            if [[ "${col_names[$i]}" == "$col_name" ]];then
                update_index=$i
            fi
        done

        if [[ "$update_index" -eq -1 ]];then
            echo -e "${RED}Column $col_name is not found ${RESET}"
            continue
        fi

        if [[ "$update_index" -eq "$pk_index" ]];then
            echo -e "${RED}Primary Key cannot be changed ${RESET}"
            continue
        fi

        echo -e "${YELLOW}${BOLD}New Value : ${RESET}"
        read new_value
        new_value=$(echo "$new_value" | tr -d '[:space:]')

        if [[ "$col_types[$update_index]" == "int" && ! "$new_value" =~ ^[0-9]+$ ]];then
            echo -e "${RED}Type does not match. please enter an integer. ${RESET}" 
            continue
        fi

        updates[$update_index]="$new_value"
    done

    if [[ ${#updates[@]} -eq 0 ]];then
        echo -e "${RED}No updates!. ${RESET}" 
        return 1
    fi

    #actually update 
    # tmp file
    tmp_file="$DB_Dir/$Curr_DB/$table/temp_file"
    > "$tmp_file"
    updated=false

    while IFS='|' read -r -a row; do
        if [[ "${row[$where_index]}" == "$where_val" ]]; then
            for index in "${!updates[@]}"; do
                row[$index]="${updates[$index]}"
            done
            updated=true
        fi
        printf "%s\n" "$(IFS='|'; echo "${row[*]}")" >> "$tmp_file"
    done < "$data_file"

    if [[ "$updated" == false ]]; then
        echo -e "${RED}No matching records${RESET}"
        rm -f "$tmp_file"
        return 1
    fi

    mv "$tmp_file" "$data_file"
    echo -e "${GREEN}${BOLD}Record updated successfully.${RESET}"

}