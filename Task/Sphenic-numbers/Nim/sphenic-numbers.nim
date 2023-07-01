import std/[algorithm, math, strformat]

proc initPrimes(lim: Positive): seq[int] =
  ## Initialize the list of prime numbers.

  # Build a sieve of Erathostenes with only odd values.
  var composite = newSeq[bool](lim div 2)
  composite[0] = true
  for n in countup(3, lim, 2):
    if not composite[(n - 1) shr 1]:
      # "n" is prime.
      for k in countup(n * n, lim, 2 * n):
        composite[(k - 1) shr 1] = true

  # Build list of primes.
  result = @[2]
  for n in countup(3, lim, 2):
    if not composite[(n - 1) shr 1]:
      result.add n

let primes = initPrimes(500_000)

type
  Factors = tuple[p1, p2, p3: int]
  Item = tuple[sphenic: int; factors: Factors]
  SphenicNumbers = seq[Item]

proc sphenicNumbers(lim: Positive): SphenicNumbers =
  ## Return a sequence of items describing sphenic numbers up to "lim".
  let lim1 = cbrt(lim.toFloat).int
  let lim2 = lim1 * lim1
  for i1 in 0..(primes.len - 3):
    let p1 = primes[i1]
    if p1 >= lim1: break
    for i2 in (i1 + 1)..(primes.len - 2):
      let p2 = primes[i2]
      let p12 = p1 * p2
      if p12 >= lim2: break
      for i3 in (i2 + 1)..(primes.len - 1):
        let p3 = primes[i3]
        let p123 = p12 * p3
        if p123 >= lim: break
        result.add (p123, (p1, p2, p3))
  result.sort()

proc sphenicTriplets(sn: SphenicNumbers): seq[int] =
  ## Return the list of first element of sphenic triplets
  ## extracted from the given sequence of sphenic numbers.
  for i in 0..(sn.len - 3):
    let start = sn[i].sphenic
    if sn[i + 1].sphenic - start == 1 and sn[i + 2].sphenic - start == 2:
      result.add start

func tripletStr(n: Positive): string =
  ## Return the representation of a sphenic triplet
  ## described by its first element.
  &"({n}, {n + 1}, {n + 2})"


echo "Sphenic numbers less than 1000:"
for i, item in sphenicNumbers(1000):
  stdout.write &"{item.sphenic:5}"
  if (i + 1) mod 15 == 0: echo()

echo "\nSphenic triplets less than 10000:"
let sn10000 = sphenicNumbers(10000)
for i, n in sphenicTriplets(sn10000):
  stdout.write "  ", n.tripletStr
  if (i + 1) mod 3 == 0: echo()

let sn1000000 = sphenicNumbers(1_000_000)
echo &"\nNumber of sphenic numbers less than one million: {sn1000000.len:7}"

let triplets1000000 = sphenicTriplets(sn1000000)
echo &"Number of sphenic triplets less than one million: {triplets1000000.len:6}"

let (num, (p1, p2, p3)) = sn1000000[200_000 - 1]
echo &"\n200_000th sphenic number:  {num} = {p1} * {p2} * {p3}"

echo &"5_000th sphenic triplet:  {triplets1000000[5_000 - 1].tripletStr}"
