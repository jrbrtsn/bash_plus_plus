#!/bin/bash
############################################################
# Example script to demonstrate a function which returns
# multiple objects without the use of subshells
#
# John Robertson <john@rrci.com>
# Initial release: Thu Sep 10 11:58:23 EDT 2020
#

# Halt on error, no globbing, no unbound variables
set -efu

# import return stack tools
source ../bash++

function returns_3_strings ()
#######################################################
# Example function with 3 returns objects
# Arguments:
#   none
# Returns:
#  3 strings
#
{
   RTN_push 'string #1' 'string #2' 'string #3'
}

###################################
### Execution starts here #########
###################################

# NOTE: We'll reserve R1 R2 R3 ... global
# variables to fetch return values from
# return stack.

# Call our function
returns_3_strings

# Pop the results into global return "registers"
RTN_pop R1 R2 R3

# print the results
echo "R1= '$R1', R2= '$R2', R3= '$R3'"
