set output=( "`grep 80/ /etc/services`" )
echo "Line 1: $output[1]"
echo "Line 2: $output[2]"
