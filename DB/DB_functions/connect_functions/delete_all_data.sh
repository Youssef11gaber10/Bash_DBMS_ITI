#!/usr/bin/env bash

function delete_all_data(){
    #Validation
    #is DB selected
    if [[ -z "$DB_Dir/$Curr_DB" ]];then
        echo -e "${RED}No database selected. please connect first.${RESET}"
        return
    fi

    list_tables
    echo -e "${YELLOW}${BOLD}Enter the name of the table you want to delete from : ${RESET}"
    read table
    #does table exist
    if [[ ! -d "$DB_Dir/$Curr_DB/$table" ]];then
        echo -e "${RED}Table doesn't exist.${RESET}"
        return
    fi

    #does meta and date files exist
    # meta_file="$DB_Dir/$Curr_DB/$table/$table.meta"
    data_file="$DB_Dir/$Curr_DB/$table/$table.data"
    if [[ ! -f "$data_file" ]]; then
        echo -e "${RED}Date file doesn't exist.${RESET}"
        return
    fi    

    echo -e "${YELLOW}Are you sure you want to delete all data from table $table ${RED}( y / n ) ${RESET}"
    read -p "answer : " answer

    if [[ "$answer" = "n" ||  "$answer" != "N" ]];then
        echo "no deletes"
        return
    else 
        >"$data_file"
    fi

    echo -e "${GREEN}All records deleted successfully.${RESET}"

}
