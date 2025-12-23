#!/usr/bin/env bash
# call script of connect menu
source ./DB/DB_functions/connect_functions/create_table.sh
source ./DB/DB_functions/connect_functions/list_tables.sh
source ./DB/DB_functions/connect_functions/drop_table.sh
source ./DB/DB_functions/connect_functions/select_table.sh
source ./DB/DB_functions/connect_functions/delete_table.sh
source ./DB/DB_functions/connect_functions/update_table.sh
source ./DB/DB_functions/connect_functions/insert_into_table.sh
source ./DB/DB_functions/connect_functions/drop_table.sh

function connect_menu()
{

while true
do
    echo -e "${BG_RED}${BOLD}Operation on ${Curr_DB} Database${RESET}"
    echo -e "${GREEN}${BOLD}${UNDERLINE}DDL Operations:${RESET}"
    echo -e "1) Create new Table"
    echo -e "2) List Tables"
    echo -e "3) Drop Table"
    echo -e "${GREEN}${BOLD}${UNDERLINE}DML Operations:${RESET}"
    echo -e "4) Insert Data into Table"
    echo -e "5) Update Data in Table"
    echo -e "6) Delete Specific Data from Table"
    echo -e "7) Delete all Data from Table"
    echo -e "${GREEN}${BOLD}${UNDERLINE}DQL Operations:${RESET}"
    echo -e "8) Select all Data from Table"
    echo -e "9) Select specific Data from Table"
    echo -e "0) Back to Main Menu"


    echo -e "${YELLOW}${BOLD}${UNDERLINE}Write your choice:${RESET}"
    read  choice

    case $choice in
        1) create_table ;;
        2) list_tables ;;
        3) drop_table ;;
        4) insert_into_table ;;
        5) update_table ;;
        6) delete_table ;;
        7) delete_all_data ;;
        8) select_table ;;
        9) select_table ;;
        0) break ;;
        *) echo -e "${RED}Invalid option. Please try again.${RESET}" ;;
    esac

    echo ""  # spacing after each action

done


}


