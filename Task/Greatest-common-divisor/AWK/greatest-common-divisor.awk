$ awk 'func gcd(p,q){return(q?gcd(q,(p%q)):p)}{print gcd($1,$2)}'
12 16
4
22 33
11
45 67
1
