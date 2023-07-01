eval_with_x() {
	set -- "`x=$2; eval "$1"`" "`x=$3; eval "$1"`"
	expr "$2" - "$1"
}

eval_with_x '
	# compute 2 ** $x
	p=1
	while test $x -gt 0; do
		p=`expr $p \* 2`
		x=`expr $x - 1`
	done
	echo $p
' 3 5
# Prints '24'
