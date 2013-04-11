sum=0
prod=1
list="1 2 3"
for n in $list
do sum="$(($sum + $n))"; prod="$(($prod * $n))"
done
echo $sum $prod
