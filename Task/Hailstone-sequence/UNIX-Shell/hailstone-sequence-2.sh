# Outputs a hailstone sequence from $1, with one element per line.
# Clobbers $n.
hailstone() {
	n=`expr "$1" + 0`
	eval "test $? -lt 2 || return $?"  # $n must be integer.

	echo $n
	while test $n -ne 1; do
		if expr $n % 2 >/dev/null; then
			n=`expr 3 \* $n + 1`
		else
			n=`expr $n / 2`
		fi
		echo $n
	done
}

set -- `hailstone 27`
echo "Hailstone sequence from 27 has $# elements:"
first="$1, $2, $3, $4"
shift `expr $# - 4`
echo "  $first, ..., $1, $2, $3, $4"

i=1 max=0 maxlen=0
while test $i -lt 1000; do
	len=`hailstone $i | wc -l | tr -d ' '`
	test $len -gt $maxlen && max=$i maxlen=$len
	i=`expr $i + 1`
done
echo "Hailstone sequence from $max has $maxlen elements."
