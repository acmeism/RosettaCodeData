import std/[algorithm, math, sugar]

proc pritchard(limit: Natural): seq[int] =
  ## Pritchard sieve of primes up to "limit".
  var members = newSeq[bool](limit + 1)
  members[1] = true
  var
    stepLength = 1
    prime = 2
    rtlim = sqrt(limit.toFloat).int
    nlimit = 2
    primes: seq[int]

  while prime <= rtlim:
    if stepLength < limit:
      for w in 1..members.high:
        if members[w]:
          var n = w + stepLength
          while n <= nlimit:
            members[n] = true
            inc n, stepLength
      stepLength = nlimit

    var np = 5
    var mcpy = members
    for w in 1..members.high:
      if mcpy[w]:
        if np == 5 and w > prime:
          np = w
        let n = prime * w
        if n > limit:
          break  # No use trying to remove items that can't even be there.
        members[n] = false  # No checking necessary now.

    if np < prime:
      break
    primes.add prime
    prime = if prime == 2: 3 else: np
    nlimit = min(stepLength * prime, limit)   # Advance wheel limit.

  let newPrimes = collect:
                    for i in 2..members.high:
                      if members[i]: i
  result = sorted(primes & newPrimes)


echo pritchard(150)
echo "Number of primes up to 1_000_000: ", pritchard(1_000_000).len
