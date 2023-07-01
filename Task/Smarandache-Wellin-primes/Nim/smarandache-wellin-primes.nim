import std/[bitops, math, strformat, strutils, sugar, tables]

import integers

const N = 12_000
let primes = @[2] & collect(for n in countup(3, N, 2):
                              if n.isPrime: n)

func compressed(str: string; size: int): string =
  ## Return a compressed value for long strings of digits.
  if str.len <= 2 * size: str
  else: &"{str[0..<size]}...{str[^size..^1]} ({str.len} digits)"

iterator swNumbers(): tuple[value: Integer; lastPrime: int] =
  ## Yield the SW-Numbers and the last prime added.
  var swString = ""
  for p in primes:
    swString.addInt p
    yield (newInteger(swString), p)

iterator derivedSwNumbers(): Integer =
  ## Yield the derived SW-Numbers.
  for (n, _) in swNumbers():
    var dSwString = ""
    let counts = toCountTable($n)
    for d in '0'..'9':
      dSwString.add $counts[d]
    yield newInteger(dSwString.strip(leading = true, trailing = false, {'0'}))

echo "Known eight Smarandache-Wellin numbers which are prime:"
var idx, count = 0
for (n, p)in swNumbers():
  inc idx
  if n.isPrime:
    inc count
    echo &"{count}:  index = {idx:<4}  last prime = {p:<5}  value = {compressed($n, 20)}"
    if count == 8: break

echo "\nFirst 20 derived S-W numbers which are prime:"
idx = 0
count = 0
for n in derivedSwNumbers():
  inc idx
  if n.isPrime:
    inc count
    echo &"{count:2}:  index = {idx:<4}  value = {n}"
    if count == 20: break
