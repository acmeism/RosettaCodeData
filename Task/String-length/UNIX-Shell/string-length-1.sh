string='Hello, world!'
length=`expr "x$string" : '.*' - 1`
echo $length # if you want it printed to the terminal
