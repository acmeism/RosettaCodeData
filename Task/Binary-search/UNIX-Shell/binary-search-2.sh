left=0
right=$(($size - 1))
while	[ $left -le $right ] ; do
	mid=$((($left + $right) >> 1))
#	echo "$left	$mid(${array[$mid]})	$right"
	if	[ $value -eq ${array[$mid]} ] ; then
		echo $mid
		exit
	elif	[ $value -lt ${array[$mid]} ]; then
		right=$(($mid - 1))
	else
		left=$((mid + 1))
	fi
done
echo 'ERROR 404 : NOT FOUND'
