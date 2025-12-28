# i want to sepcify what rows he wants to make the condition on and what is the condition
# i will allow only to = condition
#!/usr/bin/env  bash
function select_with_option()
{
    columns=($(cut -d':' -f1 "$meta_file"))
    while true
    do
        echo -e "\n${YELLOW}${BOLD}${UNDERLINE}Choose columns to diplay enter the correspond number seprated by space:${RESET}"
        ii=1
        for col in "${columns[@]}"; do
            echo -e " ($ii) $col"
            ((ii++))
        done

        echo -e "${UNDERLINE}${BOLD}${YELLOW}Enter column numbers separated by comma space like '1 2 3' :${RESET}"
        read -a selected_nums

        valid=true
        selected_columns=()
        #loop on array of numbers check if its valid numbers
        for num in "${selected_nums[@]}"
        do
            if [[ ! "$num" =~ ^[0-9]+$ ]] || (( num < 1 || num > ${#columns[@]} ))
                then
                echo -e "${RED}Invalid column number: $num${RESET}"
                valid=false
                break
            fi
            selected_columns+=("${columns[$((num-1))]}")
        done

        $valid && break

    done

    while true
    do
        echo -e "\n${YELLOW}${BOLD}${UNDERLINE}Choose column number want filter on:${RESET}"
        ii=1
        for col in "${columns[@]}"; do
            echo -e " ($ii) $col"
            ((ii++))
        done

        echo -e "${YELLOW}${BOLD}${UNDERLINE}Enter column number:${RESET}"
        read where_col_num

        if [[ ! "$where_col_num" =~ ^[0-9]+$ ]] || (( where_col_num < 1 || where_col_num > ${#columns[@]} )); then
            echo -e "${RED}Invalid column number${RESET}"
            continue
        fi

        where_col_name="${columns[$((where_col_num-1))]}"
        break
    done

    echo -e "${YELLOW}${BOLD}${UNDERLINE}for (${where_col_name} = ?) enter value to filter on :${RESET}"
    read where_value

    # this is the new header
    echo -e "\n${BOLD}${UNDERLINE}${YELLOW}$(IFS=$'\t'; echo "${selected_columns[*]}")${RESET}"

  
   awk -F'<\\|>' -v col_num="$where_col_num" -v val="$where_value" -v cols="${selected_nums[*]}" '
    BEGIN {
        split(cols, col, " ")
    }
    $col_num == val {
     
        out = ""
        for (i in col) {
            out = out $col[i] "\t"
        }
        print out
    }
    ' "$data_file"


}