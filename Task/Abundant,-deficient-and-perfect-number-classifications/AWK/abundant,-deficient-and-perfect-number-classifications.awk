#!/bin/gawk -f
function sumprop(num,   i,sum,root) {
if (num == 1) return 0
sum=1
root=sqrt(num)
for ( i=2; i < root; i++) {
    if (num % i == 0 )
    {
    sum = sum + i + num/i
    }
    }
if (num % root == 0)
   {
    sum = sum + root
   }
return sum
}

BEGIN{
limit = 20000
abundant = 0
defiecient =0
perfect = 0

for (j=1; j < limit+1; j++)
    {
    sump = sumprop(j)
    if (sump < j) deficient = deficient + 1
    if (sump == j) perfect = perfect + 1
    if (sump > j) abundant = abundant + 1
    }
print "For 1 through " limit
print "Perfect: " perfect
print "Abundant: " abundant
print "Deficient: " deficient
}
