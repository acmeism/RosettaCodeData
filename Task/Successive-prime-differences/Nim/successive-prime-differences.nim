import math, strutils

const N = 1_000_000

var comp: array[2..(N - 1), bool]   # True is composite, so default is prime.
for n in 2..<N:
  if not comp[n]:
    for k in countup(n * n, N - 1, n):
      comp[k] = true

var primes = @[2]
for n in countup(3, N - 1, 2):
  if not comp[n]:
    primes.add n

iterator groups(primes: seq[int]; diffs: varargs[int]): seq[int] =
  ## Yield groups of successive primes with given differences.
  var cumdiffs = cumsummed(diffs)   # Compute differences from first prime of group.
  let groupSize = diffs.len + 1
  for i in 0..(primes.len - groupSize):
    let p = primes[i]
    var group = @[p]
    for k, diff in cumdiffs:
      if primes[i + k + 1] != p + diff: break
      group.add p + diff
    if group.len == groupSize:
      yield group

proc findGroups(primes: seq[int]; diffs: varargs[int]) =
  ## In the given list of primes and for the given differences,
  ## find the first group, the last group and the count of groups.
  var
    first, last: seq[int]
    count = 0
  for group in primes.groups(diffs):
    if first.len == 0: first = group
    last = group
    inc count
  echo "Differences: ", diffs.join(", ")
  echo "– first: ($#)" % first.join(", ")
  echo "– last:  ($#)" % last.join(", ")
  echo "– count: ", count
  echo()

primes.findGroups(2)
primes.findGroups(1)
primes.findGroups(2, 2)
primes.findGroups(2, 4)
primes.findGroups(4, 2)
primes.findGroups(6, 4, 2)
