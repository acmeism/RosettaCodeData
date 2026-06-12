import std/[strformat, strutils]
import integers

let
  One = newInteger(1)
  Ten = newInteger(10)

proc a036229(n: Positive): Integer =
  var k = Ten^n div 9
  var r = One shl n - 1
  var m = newInteger(0)
  while m <= r:
    let t = k + newInteger(`$`(m, 2))
    if t.isprime: return t
    inc m
  quit &"No {n}-digit prime found with only digits 1 or 2.", QuitFailure

func compressed(n: Integer): string =
  let s = $n
  let idx = s.find('2')
  result = &"(1 × {idx}) " & s[idx..^1]

for n in 1..20:
  echo &"{n:4}: {a036229(n)}"
echo()
for n in countup(100, 2000, 100):
  echo &"{n:4}: {compressed(a036229(n))}"
