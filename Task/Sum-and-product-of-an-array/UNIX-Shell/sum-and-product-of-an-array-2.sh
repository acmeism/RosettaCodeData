sum=0
prod=1
for n
do sum="$(($sum + $n))"; prod="$(($prod * $n))"
done
echo $sum $prod
