#!/usr/bin/env bash

function condition(){
    local value="$1"
    local op="$2"
    local new_value="$3"

    case "$op" in
        "=") [[ "$value" == "$new_value" ]]
            ;;
        "!=") [[ "$value" != "$new_value" ]]
            ;;

        ">"|"<")
            # Validate integers
            if ! [[ "$value" =~ ^-?[0-9]+$ && "$new_value" =~ ^-?[0-9]+$ ]]; then
                echo -e "${RED}$value and $new_value must be integers${RESET}" >&2
                return 1
            fi

            case "$op" in
                ">")  (( value > new_value )) ;;
                "<")  (( value < new_value )) ;;
            esac
            ;;
        *) echo "Unsupported operator: $op" >&2
            return 1
            ;;
    esac
}