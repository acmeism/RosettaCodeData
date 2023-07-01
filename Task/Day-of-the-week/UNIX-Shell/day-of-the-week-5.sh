y=2008
while test $y -lt 2122; do
	cal 12 $y | tail +3 | cut -c1-2 | grep -Fq 25 && echo 25 Dec $y
	y=`expr $y + 1`
done
