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

# // Declaration
# class FirstClass {
#    FirstClass () // constructor
#    ~FirstClass () // destructor
#    catstr; // concatenation of constructor args
#    print() // Print
#};

function FirstClass::FirstClass ()
###################################
# Constructor for FirstClass
#
{
   local opts=$(shopt -o -p nounset)
   # Necessary to avoid "unbound variable" exception for empty stack
   set +u

   local self=$1
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
   eval $self[catstr]='$catStr'

   # Restore options
   eval $opts
}

function FirstClass::~FirstClass ()
###################################
# Destructor for FirstClass
#
{
   local self=$1

   # Free resources
   eval unset $self[catstr]
}


###################################
### Execution starts here #########
###################################

# Create an instance of FirstClass
new FirstClass 'Here are' '3 constructor' 'arguments'

# Retrieve a handle to the new object
RTN_pop h_fc

# Print object to stdout
show $h_fc

# Call a member function
#call h_fc.printCatStr '.suffix'

# Delete object
delete $h_fc



