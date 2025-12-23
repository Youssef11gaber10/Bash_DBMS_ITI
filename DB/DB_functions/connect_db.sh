# connect to a database
#means to go to specificdb and do operations there
#like ddl ,dml ,dql
#ddl : create table ,drop table ,alter table 
#dml : insert ,update ,delete
#dql : select  ,list tables

# here take the db name from user and check if exists
# if exists assign the Curr_DB variable to that name
#show him connect menu to do operations on that db
#after you finish any operation set Curr_DB back to empty string

#!/usr/bin/env bash
source ./DB/DB_functions/connect_menu.sh

function connect_db()
{
    list_databases
    while true
    do
        echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the name of the database to connect:  ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
        read db_name    

        if [ $db_name -eq  -1 ]&>/dev/null #this create error don't show not neccessary
            then
            return # back to menu
        fi  

        if [ -d "${DB_Dir}/$db_name" ]
            then
            Curr_DB=$db_name
            echo -e "${GREEN}Connected to database '$Curr_DB' successfully.${RESET}"
            sleep 2 ;
            # here call the connect menu function to do operations on that db
            connect_menu
            # after finishing operations set Curr_DB back to empty string
            Curr_DB=""
            return
        else
            echo -e "${RED}Database does not exist.${RESET}"
            sleep 2;
        fi
    done
}