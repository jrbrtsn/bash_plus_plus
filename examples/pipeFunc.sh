
#!/bin/bash
############################################################
# Example script to demonstrate a function pipeline function
#
# John Robertson <john@rrci.com>
# Initial release: Wed Sep 16 12:04:02 EDT 2020
#

# Halt on error, no globbing, no unbound variables
set -efu

# import oop facilities and other goodies
source ../bash++

function for_pipeline ()
#######################################################
# Example function to place in a pipeline
# When placed in a pipeline,  NOT a subshell
# Arguments:
#   none
# Returns:
#   return from
#
{

1>&2 echo "for_pipeline PID= $$"
   local fd tmp_fname="/tmp/$$.${FUNCNAME[0]}";
   exec {fd}> >(1>&2 wc -c)
   sed -n '1,10 p' | tee /dev/fd/$fd

#   cat $tmp_fname
#   /bin/rm $tmp_fname
   
}

###################################
### Execution starts here #########
###################################

1>&2 echo "Main PID= $$"

cat /var/log/syslog | for_pipeline | tac
