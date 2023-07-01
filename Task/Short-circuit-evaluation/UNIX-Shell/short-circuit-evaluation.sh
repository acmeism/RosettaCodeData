a() {
	echo "Called a $1"
	"$1"
}

b() {
	echo "Called b $1"
	"$1"
}

for i in false true; do
	for j in false true; do
		a $i && b $j && x=true || x=false
		echo "  $i && $j is $x"

		a $i || b $j && y=true || y=false
		echo "  $i || $j is $y"
	done
done
