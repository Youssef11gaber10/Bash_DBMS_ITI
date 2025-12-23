#showw list of databases
#ask for the name of database to drop
#check if database exists
#if exists drop it else show error message

#!/usr/bin/env bash

#no need to call listdatabses function again as its sourced from menu.sh
#something to update add ensuring message before dropping
function drop_db()
{
    list_databases

    while true;do
        echo -e "${BOLD}${YELLOW}${UNDERLINE}Enter the name of the database you want to delete ${RED}(or -1 to cancel)${RESET}: "
        read   dbname

        if [[ -z "$dbname" ]];then
            echo -e "${BOLD}${YELLOW}Database name can not be empty! ${RESET}"
            sleep 2
            continue
        fi

        if [[ "$dbname" == -1 ]];then
            return 
        elif [[ ! -d "${DB_Dir}/${dbname}" ]];then
            echo -e "${BOLD}${YELLOW}Database name can not be found! ${RESET}"
            sleep 2
            continue
        fi 

    
        read -p "Are you sure you want to delete the database '$dbname'? (y/n) (or -1 to cancel): " option
        case "$option" in
            y|Y) 
                rm -r "${DB_Dir}/${dbname}"
                if [[ $? -eq 0 ]];then
                    echo -e "${GREEN}Database '$dbname' deleted successfully ${RESET}"
                    sleep 2
                    break
                else 
                    echo -e "${RED}something went wrong${RESET}"
                    sleep 2
                    continue
                fi
                ;;
            n|N) 
                echo -e "${YELLOW}Deletion cancelled. ${RESET}"
                sleep 2
                return 1
                ;;
            -1)
                return ;;
            *)
                echo -e "${YELLOW}Invalid Option ${RESET}"
                sleep 2
                ;;
        esac
    done
}