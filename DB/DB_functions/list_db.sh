# check if dircetory is empty so doesn't have db
#if not empty list the databases
#!/usr/bin/env bash


function list_databases() 
{
if [ -z "$(ls $DB_Dir)" ] # if the ls return empty string 
        then
        echo -e "${RED}No databases found.${RESET}"
else
        echo -e "${UNDERLINE}${BOLD}${YELLOW}Available Databases:${RESET}"
        echo -e  "${BOLD}$(ls -1 "$DB_Dir" )${RESET}"
        sleep 2;

fi

}

