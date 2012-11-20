#!/bin/sh
#
echo "# echoing input from stdin - begin"
while read l ; do
    echo "$l"
done
echo "# echoing input from stdin - end"
#
echo "###"
echo "# printing output to stdout - begin"
#
for ((n=1; n<=3; n++)) ; do
    ln=$(printf %03d $n)
    echo "This could be line no. ${ln} of GULP output."
done
echo "# printing output to stdout - end"
#
