fun gcd (0,n) = n
  | gcd (m,n) = gcd(n mod m, m)

fun lcm (m,n) = abs(x * y) div gcd (m, n)
