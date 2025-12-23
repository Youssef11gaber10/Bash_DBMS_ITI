#!/usr/bin/env bash

#define some colors for gui
# Text colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
BLACK="\e[30m"

# Background colors
BG_RED="\e[41m"
BG_GREEN="\e[42m"
BG_YELLOW="\e[43m"
BG_BLUE="\e[44m"
BG_WHITE="\e[47m"
# Styles
BOLD="\e[1m"
UNDERLINE="\e[4m"

# Reset
RESET="\e[0m"

#important valriables
DB_Dir="./DB/DB_Dir" #directory for databases
Curr_DB="" #variable to hold the current connected database name , when connect to db this will be assigned

#retrive our bash scripts functions
source ./DB/DB_functions/initiate_db.sh
source ./DB/DB_functions/create_db.sh
source ./DB/DB_functions/list_db.sh
source ./DB/DB_functions/drop_db.sh
source ./DB/DB_functions/connect_db.sh
source ./GUI/functions_gui.sh


#draw the logo
drawLogo

echo -e "${BLUE}---------------------------------------------------------------------------${RESET}"
echo
echo -e "${YELLOW}                Welcome ${USER^} to Bash-DBMS System 🥳"
echo -e "${YELLOW}                Credit: Youssef_Gaber && Nouran_Ali"
echo
echo -e "${BLUE}---------------------------------------------------------------------------${RESET}"


#initiate the database directory
initiate_db

# clear
# # Display menu options
while true
do
    echo -e "${BG_RED}${BOLD}Choose an option to get started:${RESET}"
    echo -e "${GREEN}${BOLD}${UNDERLINE}Enter your choice (1-5):${RESET}"
    echo -e "1) Create New Database"
    echo -e "2) Connect to Database"
    echo -e "3) List Databases"
    echo -e "4) Drop Database"
    echo -e "5) Exit"

    echo -e "${YELLOW}${BOLD}${UNDERLINE}Write your choice:${RESET}"
    read  choice

    case $choice in
        1) create_db ;;
        2) connect_db ;;
        3) list_databases ;;
        4) drop_db ;;
        5) echo -e "${GREEN}Thank you for using Bash-DBMS. Goodbye! 👋${RESET}"; exit 0 ;;
        *) echo -e "${RED}Invalid option. Please try again.${RESET}" ;;
    esac

    echo ""  # spacing after each action

done
