#this function is used to drop a table from the current database
#take the name of the table and check if it exists and valid name and make sure he wants to delete it if yes delete its directory


#!/usr/bin/env bash
source ./DB/DB_functions/connect_functions/list_tables.sh
function drop_table()
{
    list_tables
    while true; do
        echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the name of the table to drop:  ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
        read table_name    

        if [[ "$table_name" == -1 ]]
            then
            return 
        fi  

        if [[ ! -d "${DB_Dir}/$Curr_DB/$table_name" ]]; then
            echo -e "${RED}Table does not exist in database '$Curr_DB'.${RESET}"
            sleep 2;
            continue
        fi

        echo -e "${YELLOW}Are you sure you want to delete the table '$table_name' from database '$Curr_DB'? (y/n) (or -1 to cancel): ${RESET}"
        read option
        if [[ "$option" == "y" || "$option" == "Y" ]]
            then
            rm -r "${DB_Dir}/$Curr_DB/$table_name"
            echo -e "${GREEN}Table '$table_name' deleted successfully from database '$Curr_DB'.${RESET}"
            sleep 2
            # list_tables 
            break
        elif [[ "$option" == "n" || "$option" == "N" ]]; then
            echo -e "${YELLOW}Deletion cancelled.${RESET}"
            sleep 2
            return 
        else
            echo -e "${YELLOW}Invalid Option.${RESET}"
            sleep 2
        fi
    done
    
}
        