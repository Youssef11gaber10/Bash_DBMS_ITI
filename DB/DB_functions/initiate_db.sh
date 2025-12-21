#this file used to initiate the database by create the main directory if not exists
#!/usr/bin/env bash

function initiate_db() {
    
DB_Dir="./DB/DB_Dir" #directory for databases

if ! [ -d $DB_Dir ] # if the dictory does not exist
    then 
    mkdir -p $DB_Dir #create the main directory
    echo -e "${GREEN}Database directory created successfully at ${DB_Dir}${RESET}"
    echo -e "${GREEN}Your Data will be saved at this location!${RESET}"
    erase_output 2 # erase the two lines
fi
if [ $? -eq 0 ]; then
    return 0;
else
    echo -e "${RED}Failed to create database directory. Please check permissions.${RESET}"
    exit 1
fi
}



function erase_output(){
    msg_lines=$1
        sleep 2
    # Move cursor up and clear lines
    for ((i=0; i<msg_lines; i++)); 
    do
        tput cuu1   # move cursor up one line
        tput el     # clear line
    done
}