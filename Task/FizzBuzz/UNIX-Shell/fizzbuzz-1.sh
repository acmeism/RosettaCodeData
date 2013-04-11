i=1
while expr $i '<=' 100 >/dev/null; do
	w=false
	expr $i % 3 = 0 >/dev/null && { printf Fizz; w=true; }
	expr $i % 5 = 0 >/dev/null && { printf Buzz; w=true; }
	if $w; then echo; else echo $i; fi
	i=`expr $i + 1`
done
