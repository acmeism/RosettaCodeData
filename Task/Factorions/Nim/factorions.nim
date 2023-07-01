from math import fac
from strutils import join

iterator digits(n, base: Natural): Natural =
  ## Yield the digits of "n" in base "base".
  var n = n
  while true:
    yield n mod base
    n = n div base
    if n == 0: break

func isFactorion(n, base: Natural): bool =
  ## Return true if "n" is a factorion for base "base".
  var s = 0
  for d in n.digits(base):
    inc s, fac(d)
  result = s == n

func factorions(base, limit: Natural): seq[Natural] =
  ## Return the list of factorions for base "base" up to "limit".
  for n in 1..limit:
    if n.isFactorion(base):
      result.add(n)


for base in 9..12:
  echo "Factorions for base ", base, ':'
  echo factorions(base, 1_500_000 - 1).join(" ")
