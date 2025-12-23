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
    while true # keep asking until gives you -1 to go back to menu
    do
        echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the name of the database to drop:  ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
        read db_name    

        if [ $db_name -eq  -1 ]&>/dev/null #this create error don't show not neccessary
            then
            # erase_output 2 # erase 2 lines
            return # back to menu
        fi  

        if [ -d "${DB_Dir}/$db_name" ]
            then
            if read -p "Are you sure you want to drop the database '$db_name'? This action cannot be undone. (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
                then
                rm -rf "$DB_Dir/$db_name"
                echo -e "${GREEN}Database dropped successfully.${RESET}"
                sleep 2 ; # replace erase output hold out for while then show the menu again
                # erase_output 3 # erase 2 lines of read output and the success message
                list_databases # show updated list
            else
                echo -e "${RED}Drop database operation cancelled.${RESET}"
                sleep 2 ; 
            fi

        else
            echo -e "${RED}Database does not exist.${RESET}"
            sleep 2 ; # replace erase output hold out for while then show the menu again
            # erase_output 3 # erase 2 lines
        fi
    done
}