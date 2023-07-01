#!/bin/awk -f
function sumprop(num,   i,sum,root) {
if (num < 2) return 0
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
limit=20000
print "Amicable pairs < ",limit
for (n=1; n < limit+1; n++)
    {
    m=sumprop(n)
    if (n == sumprop(m) && n < m) print n,m
    }
}
}
