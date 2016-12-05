import strutils

proc count(s, sub): int =
  var i = 0
  while true:
    i = s.find(sub, i)
    if i < 0:
      break
    inc i
    inc result

proc isSelfDescribing(n): bool =
  let s = $n
  for i, ch in s:
    if s.count($i) != parseInt("" & ch):
      return false
  return true

for x in 0 .. 4_000_000:
  if isSelfDescribing(x): echo x
