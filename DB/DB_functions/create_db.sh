# this file used to create a new database by creating a new directory inside the main database directory
#!/usr/bin/env bash 


function create_db()
{
# want to keep user untill the db_name being valid
while true
do
    echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the name of the new database: ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
    read   db_name

    if [ $db_name -eq  -1 ]&>/dev/null #this create error don't show not neccessary
        then
        # erase_output 3 # erase 2 lines
        return # back to menu
    fi

    #check if the database name is valid (not empty and no special characters)
    if [[ -z "$db_name" || ! "$db_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo -e "${RED}Invalid database name. Use only letters, numbers, and underscore ,MUST not start with number .${RESET}"
        sleep 2 ; # replace erase output hold out for while then show the menu again
        # erase_output 4 # erase 3 lines
        continue
    fi

    # validate database name its not exist before
    if [ -d "${DB_Dir}/$db_name" ]
        then
        echo -e "${RED}Database already exists.${RESET}"
        sleep 2 ; # replace erase output hold out for while then show the menu again
        # erase_output 3 # erase the 1 lines
        continue
    fi
    #if he reach this point so the db name is valid
    break
done

#  if the dbname is valid and not exist so create the folder 
mkdir -p "$DB_Dir/$db_name"
echo -e "${GREEN} Database created successfully${RESET}"
sleep 2 ; # replace erase output hold out for while then show the menu again
# erase_output 4 # erase  2 line of read output and the success message

}



function erase_output()
{
    msg_lines=$1
        sleep 3
    # Move cursor up and clear lines
    for ((i=0; i<msg_lines; i++)); 
    do
        tput cuu1   # move cursor up one line
        tput el     # clear line
    done
}