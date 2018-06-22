import unicode

proc reverse(s: var string) =
  for i in 0 .. s.high div 2:
    swap(s[i], s[s.high - i])

proc reversed(s: string): string =
  result = newString(s.len)
  for i,c in s:
    result[s.high - i] = c

proc uniReversed(s: string): string =
  result = newStringOfCap(s.len)
  var tmp: seq[Rune] = @[]
  for r in runes(s):
    tmp.add(r)
  for i in countdown(tmp.high, 0):
    result.add(toUtf8(tmp[i]))

proc isComb(r: Rune): bool =
  (r >=% Rune(0x300) and r <=% Rune(0x36f)) or
    (r >=% Rune(0x1dc0) and r <=% Rune(0x1dff)) or
    (r >=% Rune(0x20d0) and r <=% Rune(0x20ff)) or
    (r >=% Rune(0xfe20) and r <=% Rune(0xfe2f))

proc uniReversedPreserving(s: string): string =
  result = newStringOfCap(s.len)
  var tmp: seq[Rune] = @[]
  for r in runes(s):
    if isComb(r): tmp.insert(r, tmp.high)
    else: tmp.add(r)
  for i in countdown(tmp.high, 0):
    result.add(toUtf8(tmp[i]))

for str in ["Reverse This!", "as⃝df̅"]:
  echo "Original string:       ", str
  echo "Reversed:              ", reversed(str)
  echo "UniReversed:           ", uniReversed(str)
  echo "UniReversedPreserving: ", uniReversedPreserving(str)
