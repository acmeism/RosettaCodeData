# the modulo generator function
function g(x, m) {
  return (x*x + 1) % m
}

# the rho iteration
function rho(n,    x, y, d, s, lim) {
  x = 1; y = x; d = 1; s = 0
  lim =sqrt(n)
  while (d == 1 && s < lim) {
    s += 1
    x = g(x,n)
    y = g( g(y,n), n)
    d = gcd( abs(x-y), n)
    if (d == n)
      return 0                  # failure
  }
  return d                      # factor found
}

{
  i = $0
  p = rho(i)
  if( p == 0)
    print i  ": no factor found"
  else
    printf "%d = %d * %d\n",  i, p, i/p
}

# common helper functions
function gcd(x, y) {
  if (x < y) return gcd(y, x)
  while (y > 0) {
    t = x % y; x = y; y = t
  }
  return x
}

function abs(x) {
  if (x < 0)
    return -x
  return x
}
