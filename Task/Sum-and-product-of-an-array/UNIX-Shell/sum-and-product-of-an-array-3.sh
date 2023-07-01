sum=0
prod=1
while read n
do sum="$(($sum + $n))"; prod="$(($prod * $n))"
done
echo $sum $prod
