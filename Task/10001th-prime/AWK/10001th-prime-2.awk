# awk -f 10001prime.awk

# n: odd number and n>8
function IsOddPrime(n,	i,limit) {
 limit = int(sqrt(n))
 for (i=3;i <= limit;i+=2)
  if (n%i==0) return 0
 return 1
}

# pos: positive
function PrimePosition(pos,	prime){
 pos -= ( (pos==1) ? prime=2 : prime=3 ) - 1
 while (pos)
  if (IsOddPrime(prime+=2)) pos--
 return prime
}

BEGIN { print PrimePosition(10001) }

