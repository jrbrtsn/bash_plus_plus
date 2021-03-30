
#!/bin/bash
############################################################
# Example script to demonstrate bash++ regex_read function
#
# John Robertson <john@rrci.com>
# Initial release: Mon Sep 14 10:29:20 EDT 2020
# Upgraded to use hkselect: Tue Mar 30 13:32:11 EDT 2021
#

# Halt on error, no globbing, no unbound variables
set -efu

# import oop facilities and other goodies
source ../bash++

###################################
### Execution starts here #########
###################################

# Open file to supply input on file descriptor $FD.
# Use recent bash syntax to assign next unused file descriptor to variable FD.
# We do this so all standard streams remain available inside of loop for
# interactive commands.
exec {FD}</var/log/syslog

# Loop until no more data available from $FD
# Regex matches 'systemd' syslog entries, breaks out date stamp, pid, and message
while regex_read '^([^ ]+ [^ ]+ [^ ]+) .*systemd\[([^:]*)\]: (.*)' -u $FD; do

   # First fetch the number of matches from the return stack.
   RTN_pop n_matches

   # Not interested in less than perfect match
   (( n_matches == 4 )) || continue

   # Pop match results into variables
   RTN_pop full_match dateStamp pid msg
   # Clear the terminal
   clear
   echo

#  "Full match is: '$full_match'"
   echo "systemd message: pid= '$pid', dateStamp= '$dateStamp',  msg= '$msg'"

   hkselect -s 'Please select an action' '&Ignore' '&Review' '&Quit'

   case $HKSELKEY in

      i|I) ;; # no worries

      r|R) read -p 'Chase up all relevant information, present to user. [Return to continue] ';;

      q|Q) break;;

      $'\e') echo; break;;

   esac

done

