#!/use/bin/env bash

function list_tables()
{
    #check DB is selected?
    if [[ -z "$DB_Dir/$Curr_DB" ]];then
        echo -e "${RED}No database selected. please connect first.${RESET}"
        return 1
    fi

    #check DB dir exists?
    if [[ ! -d "$DB_Dir/$Curr_DB" ]];then 
        echo -e "${RED}"$DB_Dir/$Curr_DB" Datase doesn't exist${RESET}"
        return 1
    fi

    #check if the db deosnt have tables
    if [[ ! -z "$(ls -A "$DB_Dir/$Curr_DB")" ]];then 
        # list tables
        echo -e "${GREEN}${BOLD}"$Curr_DB" Tables : ${RESET}"
        ls "$DB_Dir/$Curr_DB"
    else
        echo -e "${RED}"$Curr_DB" Datase doesn't have tables yet${RESET}"
        return 1
    fi

    

}