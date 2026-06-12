import strutils, tables

func sorted(text: string; omitSpaces = false): string =
  let count = text.toCountTable()
  for c in '\0'..'\255':
    if c == ' ' and omitSpaces: continue
    result.add repeat(c, count[c])

echo sorted("The quick brown fox jumps over the lazy dog, apparently", false)
echo sorted("Now is the time for all good men to come to the aid of their country.", true)
