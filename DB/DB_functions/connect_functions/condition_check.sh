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
        ">") (( value > new_value ))
            ;;
        "<") (( value < new_value ))
            ;;
        *) echo "Unsupported operator: $op" >&2
            return 1
            ;;
    esac
}