i=10
while test $i -ge 0; do
	echo $i
	i=`expr $i - 1`
done

# or

jot - 10 0 -1

# or

seq 10 -1 0
