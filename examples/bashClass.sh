#!/bin/bash
############################################################
# Example script to demonstrate a Bash class
#
# John Robertson <john@rrci.com>
# Initial release: Fri Sep 11 16:30:37 EDT 2020
#

# Halt on error, no globbing, no unbound variables
set -efu

# import return stack tools
source ../bash++

###################################
### class FirstClass ##############
###################################

function FirstClass::FirstClass ()
###################################
# Constructor for FirstClass
#
{
   local opts=$(shopt -o -p nounset)
   # Necessary to avoid "unbound variable" exception
   set +u

   local this=$1
   shift

   # Concatenate all constructor args separated by a space
   local catStr
   while [[ -n $1 ]]; do

      if [[ -z $catStr ]]; then
         catStr="$1"
      else
         catStr="$catStr $1"
      fi

      shift
   done

   # Assign value to class member
   eval $this[catstr]='$catStr'

   # Restore options
   eval $opts
}

function FirstClass::~FirstClass ()
###################################
# Destructor for FirstClass
#
{
   local this=$1

   # Free resources
   eval unset $this[catstr]
}

function FirstClass::catstr ()
###################################
# accessor function for FirstClass
# member: catstr
# Arguments:
#   None
# Returns:
#   value of catstr
#
{
   local this=$1

   # Accessors for convenient access to member values
   eval RTN_push \"\${$this[catstr]}\"

}

function FirstClass::wordCount ()
###################################
# Return the word count of catstr
# Arguments:
#   None
# Returns:
#   Word count on the return stack
#
{
   # For clarity
   local this=$1

   # Retrive the catstr member value
   fetch $this.catstr
   RTN_pop R1

   # Run through 'wc' command, store result
   # on return stack.
   RTN_push $(wc -w <<<"$R1")

}

###################################
### Execution starts here #########
###################################

# Create an instance of FirstClass
new FirstClass 'Here are' '3 constructor' 'arguments'

# Pop the address of the object into a handle
RTN_pop h_fc

# Debug print object to stdout
show $h_fc

# Access a member value
fetch $h_fc.catstr
RTN_pop str

# Print member value
echo "catstr= '$str'"

# Get the word count
call $h_fc.wordCount
RTN_pop n
echo "word count= $n"

# Delete object
delete $h_fc



