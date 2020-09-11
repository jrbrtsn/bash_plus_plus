#!/bin/bash -eu
#
# Example of event driven Bash programming.
# John Robertson <john@rrci.com>
# Thu Sep 10 20:24:35 EDT 2020

# Halt on error, no globbing, no unbound variables
set -efu

# Launch inotifywait monitoring the syslog in a subprocess.
# Redirect stdout of subshell to pipe #3
exec 3< <(exec inotifywait -m /var/log/syslog)

# Read each line of output from inotifywait
while read -u 3 FILE OPS; do

   # stdin, stdout, stderr all available in loop

   echo "FILE= '$FILE', OPS= '$OPS'"

   # OPS are comma separated. Swap comma for space, deal with each individually.
   for op in ${OPS//,/ }; do

      # Branch on $op
      case $op in

         MODIFY)
            echo "$FILE was modified.";;

         ACCESS)
            echo "$FILE was accessed.";;

         CLOSE_NOWRITE)
            echo "$FILE was closed without changes."
            break 2;;

# Other actions go here
      esac
   done
done

# Close pipe
exec 3<&-

# Only get here on loop exit, or if inotifywait quits.
exit 0
