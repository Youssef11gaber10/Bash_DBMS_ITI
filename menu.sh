#!/usr/bin/env bash

#define some colors for gui
# Text colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"

# Background colors
BG_RED="\e[41m"
BG_GREEN="\e[42m"
BG_YELLOW="\e[43m"
BG_BLUE="\e[44m"

# Styles
BOLD="\e[1m"
UNDERLINE="\e[4m"

# Reset
RESET="\e[0m"

#important valriables
DB_Dir="./DB/DB_Dir" #directory for databases

#retrive our bash scripts functions
source ./DB/DB_functions/initiate_db.sh
source ./DB/DB_functions/create_db.sh
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


# Display menu options
echo -e "${BG_RED}${BOLD}Choose an option to get started:${RESET}"
PS3=$(echo -e "${GREEN}${BOLD}${UNDERLINE}Enter your choice (1-5): ${RESET}")
options=("Create New Database" "Connect to Database" "List Databases"  "Drop Database" "Exit")

select opt in "${options[@]}"
do
    case $opt in 
        "Create New Database") create_db ;;
        "Connect to Database") echo "not finished" ;;
        "List Databases") echo "not finished" ;;
        "Drop Database") echo "not finished" ;;
        "Exit") echo -e "${GREEN}Thank you for using Bash-DBMS System. Goodbye! 👋${RESET}"
                 exit 0 ;;
        *) echo -e "${RED}Invalid option. Please try again.${RESET}" ;;
    esac
done

