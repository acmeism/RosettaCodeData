x=2
while test $x -le 8; do
	echo $x
	x=`expr $x + 2` || exit $?
done
