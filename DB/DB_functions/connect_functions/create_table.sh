#!/usr/bin/env bash

function create_table()
 {
    if [[ -z "$DB_Dir/$Curr_DB" ]];then
        echo -e "${RED}No database selected. please connect first.${RESET}"
        sleep 2
        return 1
    fi

    #table
    while true; do
        read -p "Enter the table name: " tname
        if [[ -z "$tname" ]];then
            echo -e "${RED}Table name can not be empty! ${RESET}"
            sleep 2
        elif [[ ! "$tname" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]];then  
            echo -e "${RED}Invalid table name! ${RESET}"
            sleep 2
        elif [[ -f "$DB_Dir/$Curr_DB/${tname}.meta" ]];then
            echo -e "${YELLOW}'$tname' already exists! ${RESET}"
            sleep 2
        else
            break
        fi
    done


    # columns
    declare -a columns
    declare -a types

    while true; do
        read -p "Enter the number of columns in table: " cols

        if [[ ! $cols =~  ^[1-9][0-9]*$ ]];then
            echo -e "${RED}You must enter a number! ${RESET}"
            sleep 2
        else
            break
        fi
    done

    for (( i=0; i<cols; i++));do
        while true; do
            read -p "Enter the column name " colName
            # check column
            if [[ ! $colName =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]];then
                echo -e "${RED}Invalid column name${RESET}"
                sleep 2
                return 1
            # check duplicate
            elif [[ " ${columns[*]} " == *" $colName "* ]]; then
                echo -e "${RED}Column '$colName' already exists. Choose another name.${RESET}"
                sleep 2
                return 1
            else
                break
            fi
        done

        while true; do
            read -p "Enter the column data type int/string " colType
            case $colType in
                int)
                    echo -e "${GREEN}column data type is set to int${RESET}" 
                    sleep 2
                    break
                    ;;
                string)
                    echo -e "${GREEN}column data type is set to string${RESET}" 
                    sleep 2
                    break
                    ;;
                *) 
                    echo -e "${RED}Enter a valid choice${RESET}"
                    
                    sleep 2
                    ;;
            esac
        done

        columns+=("${colName}")
        types+=("${colType}")
    done

    #PK
    while true;do
        read -p "Enter the column name to be the Primary Key: " pk
        pk_found=false;
        for col in "${columns[@]}" ;do
            if [[ "$pk" == "$col" ]];then
                pk_found=true
                break
            fi
        done
    
        if [[ "$pk_found" == true ]];then
            echo -e "${GREEN}''$col' is set the PK${RESET}" 
            break
        else
            echo -e "${RED}{$pk} doesn't exisit! ${RESET}"
        fi
    done

    # create table directory and files~
    table_dir="$DB_Dir/$Curr_DB/${tname}"
    mkdir -p "$table_dir"
    meta_file="$table_dir/${tname}.meta"
    data_file="$table_dir/${tname}.data"


    #write the schema to file
    for i in "${!columns[@]}";do
        if [[ "${columns[$i]}" == "$pk" ]];then
            echo "${columns[$i]}:${types[$i]}:PK" >> "$meta_file"
        else
            echo "${columns[$i]}:${types[$i]}:NO" >> "$meta_file"
        fi
    done

    # create data file
    touch "$data_file"

    if [[ $? -eq 0 ]];then
        echo -e "${GREEN}Table '$tname' created successfully.${RESET}"
        sleep 2
    else
        echo -e "${RED}Failed to create table.${RESET}"
        return 1
        sleep 2
    fi


}

