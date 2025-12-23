# check if dircetory is empty so doesn't have db
#if not empty list the databases
#!/usr/bin/env bash


function list_databases() 
{
    if [[ -z "$DB_Dir" || -z $(ls -A "$DB_Dir") ]];then
        echo -e "${YELLOW}You dont have any databases in your system${RESET}"
        sleep 2
        return 1;
    fi

    echo -e "${BOLD}Available Databases:${RESET}"
    for db in "$DB_Dir"/*/;do
        echo -e "- ${GREEN}$(basename "$db")${RESET}"
    done

    if [[ $? -eq 0 ]];then
        echo -e "${GREEN}Databases listed successfully${RESET}"
        sleep 2
    fi

}

