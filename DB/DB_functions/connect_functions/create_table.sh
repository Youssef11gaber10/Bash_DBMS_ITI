#!/usr/bin/env bash
# create a new table in the connected database
# prompt for table name and number of columns
# loop to get column names and data types
# save the table structure in a file
# create a file with table name in the current db directory

function create_table()
{
    #this while get the name of the table and validate it
    while true 
    do
        echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the name of the new table: ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
        read table_name

        if [ $table_name -eq  -1 ]&>/dev/null #this create error don't show not neccessary
            then
            return # back to connect menu
        fi  

        #check if the table name is valid (not empty and no special characters)
        if [[ -z "$table_name" || ! "$table_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            echo -e "${RED}Invalid table name. Use only letters, numbers, and underscore ,MUST not start with number .${RESET}"
            sleep 2 ; # replace erase output hold out for while then show the menu again
            continue
        fi

        # validate table name its not exist before
        if [ -f "${DB_Dir}/$Curr_DB/$table_name" ]
            then
            echo -e "${RED}Table already exists.${RESET}"
            sleep 2 ; # replace erase output hold out for while then show the menu again
            continue
        fi
        #if he reach this point so the table name is valid
        break
    done
    #this while get the number of columns and validate it
    while true
    do
        echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the number of columns: ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
        read num_columns

        if [ $num_columns -eq  -1 ]&>/dev/null #this create error don't show not neccessary
            then
            return # back to connect menu
        fi  

        #check if the input is a positive integer
        if ! [[ "$num_columns" =~ ^[1-9][0-9]*$ ]]; then
            echo -e "${RED}Invalid number of columns. Please enter a positive integer.${RESET}"
            sleep 2 ; # replace erase output hold out for while then show the menu again
            continue
        fi
        #if he reach this point so the num_columns is valid
        break
    done
    #this loop to get the column names and data types
    columns=""
    for (( i=1; i<=num_columns; i++ ))
    do
        while true
        do
            echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the name of column $i: ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
            read column_name

            if [ $column_name -eq  -1 ]&>/dev/null #this create error don't show not neccessary
                then
                return # back to connect menu
            fi  

            #check if the column name is valid (not empty and no special characters)
            if [[ -z "$column_name" || ! "$column_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                echo -e "${RED}Invalid column name. Use only letters, numbers, and underscore ,MUST not start with number .${RESET}"
                sleep 2 ; # replace erase output hold out for while then show the menu again
                continue
            fi

            # validate column name its not exist before in this table
            if [[ $columns == *"$column_name"* ]]; then
                echo -e "${RED}Column already exists in this table.${RESET}"
                sleep 2 ; # replace erase output hold out for while then show the menu again
                continue
            fi

            break
        done
        while true
        do
            echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the data type of column $i (int/string): ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
            read data_type

            if [ $data_type -eq  -1 ]&>/dev/null #this create error don't show not neccessary
                then
                return # back to connect menu
            fi  

            #check if the data type is valid (int or string)
            if [[ "$data_type" != "int" && "$data_type" != "string" ]]; then
                echo -e "${RED}Invalid data type. Please enter 'int' or 'string'.${RESET}"
                sleep 2 ; # replace erase output hold out for while then show the menu again
                continue
            fi
            break
        done
        columns+=":$column_name:$data_type"

    done

    pk=""
    #ask if he want to add primary key and ask if yes which column name
    while true
    do
        echo -e "${YELLOW}${UNDERLINE}${BOLD}Do you want to set a primary key for this table? (y/n):${RESET}"
        read pk_choice
        if [[ "$pk_choice" == "y" || "$pk_choice" == "Y" ]]
            then
            while true
            do
                echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the column name to set as primary key: ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
                read pk_column
                if [ $pk_column -eq  -1 ]&>/dev/null #this create error don't show not neccessary
                    then
                    return  # back to connect menu
                fi  
                #check if the column name exists in the table
                if [[ $columns == *":$pk_column:"* ]]
                    then
                    pk+="$pk_column"
                    break 2; # exit both loops 
                else
                    echo -e "${RED}Column does not exist in this table. Please enter a valid column name.${RESET}"
                    sleep 2 ; 
                fi
            done
        elif [[ "$pk_choice" == "n" || "$pk_choice" == "N" ]]
            then
            break # exit the pk setting loop
        else
            echo -e "${RED}Invalid choice. Please enter 'y' or 'n'.${RESET}"
            sleep 2 ; 
        fi
    done

    #save the table structure in a file
    
    echo "${columns:1}" > "${DB_Dir}/$Curr_DB/$table_name"
    echo $num_columns >> "${DB_Dir}/$Curr_DB/$table_name"  # number of columns
    if [[ -n "$pk" ]]; 
        then
        echo "pk:$pk" >> "${DB_Dir}/$Curr_DB/$table_name"  # primary key
    fi

    echo -e "${GREEN}Table '$table_name' created successfully in database '$Curr_DB'.${RESET}"
    sleep 2 ; # replace erase output hold out for while then show the menu again
}
