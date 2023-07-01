for f in input.txt /input.txt; do
	test -f "$f" && r=true || r=false
	echo "$f is a regular file? $r"
done
for d in docs /docs; do
	test -d "$d" && r=true || r=false
	echo "$d is a directory? $r"
done
