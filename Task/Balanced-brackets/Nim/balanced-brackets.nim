import random
randomize()

proc shuffle(s: var string) =
  for i in countdown(s.high, 0):
    swap(s[i], s[random(s.len)])

proc gen(n: int): string =
  result = newString(2 * n)
  for i in 0 .. <n:
    result[i] = '['
  for i in n .. <(2*n):
    result[i] = ']'
  shuffle(result)

proc balanced(txt: string): bool =
  var b = 0
  for c in txt:
    case c
    of '[':
      inc(b)
    of ']':
      dec(b)
      if b < 0: return false
    else: discard
  b == 0

for n in 0..9:
  let s = gen(n)
  echo "'", s, "' is ", (if balanced(s): "balanced" else: "not balanced")
