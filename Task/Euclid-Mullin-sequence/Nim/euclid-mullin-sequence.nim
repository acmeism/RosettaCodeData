import integers

let
  Zero = newInteger()
  One = newInteger(1)
  Two = newInteger(2)
  Three = newInteger(3)
  Five = newInteger(5)
  Ten = newInteger(10)
  Max = newInteger(100000)
  None = newInteger(-1)

proc pollardRho(n, c: Integer): Integer =

  template g(x: Integer): Integer = (x * x + c) mod n

  var
    x = newInteger(2)
    y = newInteger(2)
    z = newInteger(1)
    d = Max + 1
    count = 0
  while true:
    x = g(x)
    y = g(g(y))
    d = abs(x - y) mod n
    z *= d
    inc count
    if count == 100:
      d = gcd(z, n)
      if d != One: break
      z = newInteger(1)
      count = 0
  result = if d == n: Zero else: d

template isEven(n: Integer): bool = isZero(n and 1)

proc smallestPrimeFactorWheel(n: Integer): Integer =
  if n.isPrime(5): return n
  if n.isEven: return Two
  if isZero(n mod 3): return Three
  if isZero(n mod 5): return Five
  var k = newInteger(7)
  var i = 0
  const Inc = [4, 2, 4, 2, 4, 6, 2, 6]
  while k * k <= n:
    if isZero(n mod k): return k
    k += Inc[i]
    if k > Max: return None
    i = (i + 1) mod 8

proc smallestPrimeFactor(n: Integer): Integer =
  var n = n
  result = smallestPrimeFactorWheel(n)
  if result != None: return
  var c = One
  result = newInteger(n)
  while n > Max:
    var d = pollardRho(n, c)
    if d.isZero:
      if c == Ten:
        quit "Pollard Rho doesn't appear to be working.", QuitFailure
      inc c
    else:
      # Can't be sure PR will find the smallest prime factor first.
      result = min(result, d)
      n = n div d
      if n.isPrime(2):
        return min(result, n)

proc main() =
  var k = 19
  echo "First ", k, " terms of the Euclid–Mullin sequence:"
  echo 2
  var prod = newInteger(2)
  var count = 1
  while count < k:
    let t = smallestPrimeFactor(prod + One)
    echo t
    prod *= t
    inc count

main()
