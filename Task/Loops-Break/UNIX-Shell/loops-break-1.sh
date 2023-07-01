while true; do
	a=`jot -w %d -r 1 0 20` || exit $?
	echo $a
	test 10 -eq $a && break
	b=`jot -w %d -r 1 0 20` || exit $?
	echo $b
done
