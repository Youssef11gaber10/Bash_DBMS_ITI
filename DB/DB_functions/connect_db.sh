
#!/usr/bin/env bash
source ./DB/DB_functions/connect_menu.sh

function connect_db()
{
    list_databases

    while true
    do
        echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the name of the database to connect:  ${RED}(-1<---)${RESET}"
        read -r db_name

        if [ "$db_name" = "-1" ]; then
            return
        fi

        if [ -z "$db_name" ]; then
            echo -e "${RED}Database name can't be empty.${RESET}"
            sleep 2
            continue
        fi

        if [[ ! "$db_name" =~ ^[a-zA-Z0-9_]+$ ]]; then
            echo -e "${RED}Invalid database name. Only letters, numbers, and underscore (_) are allowed.${RESET}"
            sleep 2
            continue
        fi

        if [ -d "${DB_Dir}/${db_name}" ]; then
            Curr_DB="$db_name"
            echo -e "${GREEN}Connected to database '$Curr_DB' successfully.${RESET}"
            sleep 2

            connect_menu

            Curr_DB=""
            return
        else
            echo -e "${RED}Database does not exist.${RESET}"
            sleep 2
        fi
    done
}
