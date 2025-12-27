# get the data file echo it line by line
#!/usr/bin/env  bash
function select_all_data()
{
    echo -e "${GREEN}Selecting all data for table "$table_name"...${RESET}"
    
    # prints column name
    echo -e "\n${BOLD}${UNDERLINE}${YELLOW}$header${RESET}" # the header value comes from select table 

    # while IFS="" read -r line
    # do
    # echo -e "${BOLD}${line}${RESET}" | tr '<|>' '\t'
    awk 'gsub(/<\|>/,"\t") ' $data_file
    # done < $data_file
}