# this file used to create a new database by creating a new directory inside the main database directory
#!/usr/bin/env bash 


function create_db()
{
    while true; do
        echo -e "${BOLD}${YELLOW}${UNDERLINE}Enter the name of the Database: ${RED}(-1 to cancel)${RESET}"
        read dbname

        if [[ -z $dbname ]];then
            echo -e "${BOLD}${YELLOW}Database name can not be empty!${RESET}"
            sleep 2
            continue
        fi

        if [[ ! $dbname =~ ^[a-zA-Z0-9_-]+$ ]];then
            echo -e "${BOLD}${YELLOW}Invalid database name ! Use only letters, numbers, underscores or dashes can't have spaces${RESET}"
            sleep 2
            continue
        fi

        if [[ -d "${DB_Dir}/$dbname"  ]];then
            echo -e "${BOLD}${YELLOW}Database '$dbname' already exists!${RESET}"
            sleep 2
            continue
        fi

        if [[ "$dbname" == -1 ]];then
            return 1
        fi

        mkdir -p "${DB_Dir}/$dbname"
        
        if [[ $? -eq 0 ]];then
            echo -e "${BOLD}${GREEN}Database '$dbname' created succesfully at ${DB_Dir}/${dbname}${RESET}"
            sleep 2
            break
        else 
            echo -e "${BOLD}${YELLOW}Failed to create the database '$dbname' ${RESET}"
            sleep 2
            break
        fi
    done

}

