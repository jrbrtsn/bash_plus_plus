#!/bin/bash

set -efu

# import return stack tools
source ../bash++

# "static" array of phrases to be assembled into
# a sentence by recurse()
declare -a Phrase_arr=(\
[0]='Now is' \
[1]='the time for' \
[2]='all good' \
[3]='men to come' \
[4]='to the aide of' \
[5]='their country'\
)

# Convenient "constant"
Phrase_arr_sz=${#Phrase_arr[@]}

function recurse ()
#######################################################
# Example recursive function works without subshells
# Arguments:
#   Recursion level
# Returns:
#   contcatenated phrases
#
{
   local lvl=$1

   # Continue recursing until out of phrases
   if (( lvl + 1 < Phrase_arr_sz )); then

      # Call ourself again with incremented lvl
      recurse $(( lvl + 1 ))

      # Pop the result into R1
      RTN_pop R1

      # Push concatenated result on return stack
      RTN_push "${Phrase_arr[$lvl]} $R1"

   else

      # Push final phrase on return stack
      RTN_push "${Phrase_arr[$lvl]}"

   fi
}

###################################
### Execution starts here #########
###################################

# NOTE: We'll reserve R1 R2 R3 ... global
# variables to fetch return values from
# return stack.

# Recursively assemble sentence from Phrase_arr
recurse 0

# Retrieve sentence from return stack
RTN_pop R1

# Print result
echo "Result: '$R1'"

