#!/bin/sh
n=5;
k=3;
calculate_factorial(){
partial_factorial=1;
for (( i=1; i<="$1"; i++ ))
do
    factorial=$(expr $i \* $partial_factorial)
    partial_factorial=$factorial

done
echo $factorial
}

n_factorial=$(calculate_factorial $n)
k_factorial=$(calculate_factorial $k)
n_minus_k_factorial=$(calculate_factorial `expr $n - $k`)
binomial_coefficient=$(expr $n_factorial \/ $k_factorial \* 1 \/ $n_minus_k_factorial )

echo "Binomial Coefficient ($n,$k) = $binomial_coefficient"
