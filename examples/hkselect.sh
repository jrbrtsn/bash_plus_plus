#!/bin/bash
##############################################################
#  Script to demonstrate use of hkselect() function in bash++
#
# John Robertson <john@rrci.com>
# Initial release: Tue Mar 30 11:02:44 EDT 2021
#

# Halt on error, no globbing, no unbound variables
set -efu

# import bash++ facilities
source ../bash++

# Flag so we know when a bound key was pressed
is_boundKey=0

function FnKey_cb
###############################################################
# This function is bound to function keys
{
   1>&2 echo -en "\nI can see you've pressed $1\nPress return to continue "
   read
   # Note that a bound key callback cause hkselect() to return.
   is_boundKey=1
}

###################################
### Execution starts here #########
###################################

# Data might come from a dynamic source, like a file or pipe or ...
declare -a DATA_CHOICES=([0]=one [1]=two [2]=three)

# Strings we'll use repeatedly
PAD="    "
REBUKE="${PAD}$(tput bold)Please make a selection, or press a function key.$(tput sgr0)"
SUBTITLE="${PAD}You will write awesome programs with $(tput bold)bash++$(tput sgr0)"

# Loop processing user keystrokes
while true; do
   # Clear the terminal
   tput clear

   # Print banner
   1>&2 echo -e "\n${PAD}$(tput rev)Welcome to the hkselect example program$(tput sgr0)"
   1>&2 echo -e "${PAD}$(tput bold)Press a function key!$(tput sgr0)"

   # Wait for user to press a valid key
   hkselect \
      -r "$REBUKE"\
      -s "$SUBTITLE"\
      -p 4 \
      -b $(tput kf1)'|FnKey_cb|F1' \
      -b $(tput kf2)'|FnKey_cb|F2' \
      -b $(tput kf3)'|FnKey_cb|F3' \
      "${DATA_CHOICES[@]}"\
      '&Shout hurray!' 'E&xit'

   # Handle known hotkeys first
   case $HKSELKEY in

      s|S)
         1>&2 echo -en 'Hurray!\nPress return to continue '
         read discard
         ;;

      x|X) break;;

      *)
         if (( !is_boundKey )); then
            # If we get to here, then an automatically assigned hotkey was pressed
            1>&2 echo -en "Thank you for selecting '${DATA_CHOICES[$REPLY]}'.\nPress return to continue "
            read
         fi
         ;;

   esac
   is_boundKey=0
done
