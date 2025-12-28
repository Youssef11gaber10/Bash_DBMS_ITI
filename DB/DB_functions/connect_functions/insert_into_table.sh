#this function is used to insert a new record into a specified table in the database.
#so you should get the metadata of the table to know the columns and their types and if there is a primary key
#then you will prompt the user to enter values for each column while validating the input based on the column type and primary key constraints.
#so first of all i want you to take from the user the table name to insert into it
#then ask for number of rows he wants to insert
#then for each row ask for each column value and validate it based on its type and primary and data type and if pk can't be null 
#then finally append the new record to the table file.
function insert_into_table()    
{
    list_tables #to show available tables
    # get table name
    while true 
    do
        echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the name of the table to insert into:  ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
        read table_name
        if [[ "$table_name" == -1 ]]
            then
            return
        fi
        #check if not empty 
        if [[ -z "$table_name" ]]
            then
            echo -e "${RED}Table name can not be empty! ${RESET}"
            sleep 2
            continue
        fi
        #check if its valid name
        if [[ ! "$table_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]
            then  
            echo -e "${RED}Invalid table name! ${RESET}"
            sleep 2
            continue
        fi
        #check if table exists
        if [[ ! -d "$DB_Dir/$Curr_DB/$table_name" ]]
            then
            echo -e "${RED}Table '$table_name' does not exist in database '$Curr_DB'.${RESET}"
            sleep 2
            # list_tables
            continue
        
        #check if the data and meta files exist
        elif [[ ! -f "$DB_Dir/$Curr_DB/$table_name/${table_name}.meta" || ! -f "$DB_Dir/$Curr_DB/$table_name/${table_name}.data" ]]&>/dev/null
            then
            echo -e "${RED}Table '$table_name' is corrupted. Missing data or metadata files can't done insert opeartion.${RESET}"
            echo -e "${YELLOW}Please contact the administrator to fix the issue.${RESET}"
            sleep 2
            return 
        fi
        break
    done

    meta_file="$DB_Dir/$Curr_DB/$table_name/${table_name}.meta"
    data_file="$DB_Dir/$Curr_DB/$table_name/${table_name}.data"

    declare -A columns # associative array to hold column name as key and type and pk info as value
    declare -a columns_order #the associative array is not order so need to preserve the order of array

    #read metadata to get columns info
    while IFS=: read -r col_name col_type col_constraint
    do
        columns[$col_name]="$col_type:$col_constraint"
        columns_order+=("$col_name")
    done < "$meta_file"


    # get number of rows to insert
    while true
    do
        echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the number of rows to insert:${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
        read num_rows
        if [[ ! "$num_rows" =~ ^[1-9][0-9]*$ ]]
            then
            echo -e "${RED}You must enter a valid positive number! ${RESET}"
            sleep 2
            continue
        fi
        break
    done


    # insert rows
    for ((i=1; i<=num_rows; i++))
    do
        c=1 #this is counter for number of columns that is pk

        #show the table structure before each insert opearion
        for col in "${columns_order[@]}" # not the associative one
        do
            echo -e "${BOLD}${UNDERLINE}${BLUE}Column: $col , Type: ${columns[$col]}${RESET}"
        done

        #start inserting values for each column
        echo -e "${GREEN}${BOLD}Inserting row $i of $num_rows into table '$table_name':${RESET}"

        row_to_insert=""  # string will have the values of the colums sperated with :

        for col_name in "${columns_order[@]}" # this loops over the keys like id name age    
        do

            IFS=":" read -r col_type is_pk <<<  "${columns[$col_name]}" # this will be int:no or int:PK so seprate them
            while true
            do
                echo -e "${YELLOW}Enter value for column '$col_name' (type: $col_type) :(you can enter 'NULL' if its not pk)${RESET}"
                read col_value

                #this for string if it null put its value null cause there's no check for it
                if [[ "$col_value" == "NULL" || -z "$col_value" ]]
                    then
                    col_value="NULL"
                fi

                # validate based on type
                if [[ "$col_type" == "int" ]]
                    then
                    if [[ -z "$col_value" || "$col_value" == "NULL" ]]
                        then
                        col_value="NULL"
                    elif [[ ! "$col_value" =~ ^-?[0-9]+$ ]]
                        then
                        echo -e "${RED}Invalid input. Column '$col_name' requires an integer value.${RESET}"
                        sleep 2
                        continue
                    fi
                fi

                # no need check for string type as any input is valid except if it is pk

                # validate primary key constraint
                if [[ "$is_pk" == "PK" ]]
                    then
                    if [[  "$col_value" == "NULL"  ]]
                        then
                        echo -e "${RED}Primary key column '$col_name' cannot be null.${RESET}"
                        sleep 2
                        continue
                    fi

                    # # check if colv_al exist before in its field
                    if [[ ! -z $(awk -F'<\\|>' -v col="$c" '{ print $col }' "$data_file" | grep -Fx "$col_value") ]] #it wasn't empty has this value before error
                        then
                        echo -e "${RED}Duplicate primary key value!${RESET}"
                        sleep 2
                        continue
                    fi
    
                fi 
                ((c++)) #increase the counter of the column
                break #take another column for this row 

            done
                #add this value to the row will insert#change the delimiter from : to <|>
                row_to_insert+="<|>$col_value"
            
        done

        #if you get here its time to insert your row to file data
        echo "${row_to_insert:3}" >> $data_file
        echo -e "${GREEN}✔ row $i inserted successfully in table:'$table_name'.${RESET}"
        sleep 2        
    done

    echo -e "${GREEN}✔ Data inserted successfully into table '$table_name'.${RESET}"
    sleep 2

    

} # end of function


























# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
    this while get the name of the table and validate it
    # while true 
    # do
        # echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the name of the new table: ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
        # read table_name
# 
        # if [ $table_name -eq  -1 ]&>/dev/null #this create error don't show not neccessary
            # then
            # return # back to connect menu
        # fi  
# 
        check if the table name is valid (not empty and no special characters)
        # if [[ -z "$table_name" || ! "$table_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            # echo -e "${RED}Invalid table name. Use only letters, numbers, and underscore ,MUST not start with number .${RESET}"
            # sleep 2 ; # replace erase output hold out for while then show the menu again
            # continue
        # fi
# 
        validate table name its no directory exist before in the current db
        # if [ -d "${DB_Dir}/$Curr_DB/$table_name" ]
            # then
            # echo -e "${RED}Table already exists.${RESET}"
            # sleep 2 ; # replace erase output hold out for while then show the menu again
            # continue
        # fi
        if he reach this point so the table name is valid
        # break
    # done
    # 
    this while get the number of columns and validate it
    # while true
    # do
        # echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the number of columns: ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
        # read num_columns
# 
        # if [ $num_columns -eq  -1 ]&>/dev/null #this create error don't show not neccessary
            # then
            # return # back to connect menu
        # fi  
# 
        check if the input is a positive integer
        # if ! [[ "$num_columns" =~ ^[1-9][0-9]*$ ]]; then
            # echo -e "${RED}Invalid number of columns. Please enter a positive integer.${RESET}"
            # sleep 2 ; # replace erase output hold out for while then show the menu again
            # continue
        # fi
        if he reach this point so the num_columns is valid
        # break
    # done
    this loop to get the column names and data types
    # columns=""
    # for (( i=1; i<=num_columns; i++ ))
    # do
        # while true
        # do
            # echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the name of column $i: ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
            # read column_name
# 
            # if [ $column_name -eq  -1 ]&>/dev/null #this create error don't show not neccessary
                # then
                # return # back to connect menu
            # fi  
# 
            check if the column name is valid (not empty and no special characters)
            # if [[ -z "$column_name" || ! "$column_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                # echo -e "${RED}Invalid column name. Use only letters, numbers, and underscore ,MUST not start with number .${RESET}"
                # sleep 2 ; # replace erase output hold out for while then show the menu again
                # continue
            # fi
# 
            validate column name its not exist before in this table
            # if [[ $columns == *"$column_name"* ]]; then
                # echo -e "${RED}Column already exists in this table.${RESET}"
                # sleep 2 ; # replace erase output hold out for while then show the menu again
                # continue
            # fi
# 
            # break
        # done
        # while true
        # do
            # echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the data type of column $i (int/string): ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
            # read data_type
# 
            # if [ $data_type -eq  -1 ]&>/dev/null #this create error don't show not neccessary
                # then
                # return # back to connect menu
            # fi  
# 
            check if the data type is valid (int or string)
            # if [[ "$data_type" != "int" && "$data_type" != "string" ]]; then
                # echo -e "${RED}Invalid data type. Please enter 'int' or 'string'.${RESET}"
                # sleep 2 ; # replace erase output hold out for while then show the menu again
                # continue
            # fi
            # break
        # done
        # columns+=":$column_name:$data_type"
# 
    # done
# 
    # pk=""
    the users must enter name of column that he want to set as primary key
    # while true
    #   do
        # echo -e "${YELLOW}${UNDERLINE}${BOLD}Enter the column name to set as primary key: ${RED}${UNDERLINE}${BOLD}(-1<---)${RESET}"
        # read pk_column
        # if [ $pk_column -eq  -1 ]&>/dev/null #this create error don't show not neccessary
            # then
            # return  # back to connect menu
        # fi  
        check if the column name exists in the table
        # if [[ $columns == *":$pk_column:"* ]]
            # then
            # pk+="$pk_column"
            # break 2; # exit both loops 
        # else
            # echo -e "${RED}Column does not exist in this table. Please enter a valid column name.${RESET}"
            # sleep 2 ; 
        # fi
    # done
# 
    make directory with the table name and make 2 files inside it one for data and another for metadata
    # mkdir -p "${DB_Dir}/$Curr_DB/$table_name"
    # touch "${DB_Dir}/$Curr_DB/$table_name/data"
    # touch "${DB_Dir}/$Curr_DB/$table_name/metadata"
    save the table structure in the metadata file
# 
    # echo "${columns:1}" > "${DB_Dir}/$Curr_DB/$table_name/metadata"  # column definitions
    # echo $num_columns >> "${DB_Dir}/$Curr_DB/$table_name/metadata"  # number of columns
    # if [[ -n "$pk" ]]; 
        # then
        # echo "pk:$pk" >> "${DB_Dir}/$Curr_DB/$table_name/metadata"  # primary key
    # fi
# 
    # echo -e "${GREEN}Table '$table_name' created successfully in database '$Curr_DB'.${RESET}"
    # sleep 2 ; # replace erase output hold out for while then show the menu again
# 