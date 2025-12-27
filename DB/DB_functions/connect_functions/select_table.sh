#this function at first choose one option 
#!/usr/bin/env bash
source DB/DB_functions/connect_functions/select/select_all.sh
source DB/DB_functions/connect_functions/select/select_option.sh
function select_table()
{
    #get the files of table you want to select from 
    # get the name of the table you want to select from 
    while true 
    do
        list_tables
        echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the name of the table you want to select data from it ${BOLD}${UNDERLINE}${RED}(-1 <----) ${RESET}"
        read table_name

        if [[ $table_name == -1 ]]
            then
            return
        fi
        if [[ -z "$table_name" || ! "$table_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            echo -e "${RED}Invalid table name. .${RESET}"
            sleep 2 ; 
            continue
        fi

        # check if the table exist
        if [ ! -d "${DB_Dir}/$Curr_DB/$table_name" ]
            then
            echo -e "${RED}Table not exists${RESET}"
            sleep 2 ; # replace erase output hold out for while then show the menu again
            continue
        fi
        #if he reach this point so the table name is valid
        break
        
    done
    # after this you have the table name get the metadata file and datafile
    meta_file="$DB_Dir/$Curr_DB/$table_name/${table_name}.meta"
    data_file="$DB_Dir/$Curr_DB/$table_name/${table_name}.data"
    # get the columns name to put it at first of output 
    header=$(cut -d: -f1 "$meta_file" | tr '\n' '\t')

    #check if he wants select all or with option
    while true
    do
        echo -e "${YELLOW}${UNDERLINE}${BOLD}Do you want to select with options? (y/n)${BOLD}${UNDERLINE}${RED}(-1 <----) ${RESET}"
        read option

        if [[ $option == -1 ]]
            then
            return
        fi
        #if its with option or not get the column names to put at first of output
    
        if [[ $option == [y] || $option == [Y] ]]
            then
            select_with_option
            sleep 4
            break
        elif [[ $option == [n] || $option == [N] ]]
            then
            select_all_data
            sleep 4
            break
        else
            echo -e "${RED}Invalid option! Please enter y or n.${RESET}"
            sleep 2
            continue
        fi
        # break 
    done
}