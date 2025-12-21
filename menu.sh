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

source ./GUI/functions_gui.sh

echo ---------------------------------------------------------------------------
echo
echo "                Welcome ${USER^} to Bash-DBMS System 🥳"
echo "                 Developed by: Youssef_Gaber  && Nouran_Ali"
echo
echo ---------------------------------------------------------------------------

drawLogo