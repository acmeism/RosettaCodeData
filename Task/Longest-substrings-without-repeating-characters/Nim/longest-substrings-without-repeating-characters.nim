import sequtils, strutils, unicode

type Runes = seq[Rune]

func longestSubstrings(str: string): seq[string] =
  var runes = str.toRunes
  var current: Runes
  var res: seq[Runes]   # Result as a list of Runes.
  var maxlen = 0
  for c in runes:
    let idx = current.find(c)
    if idx >= 0:
      if current.len > maxlen:
        res = @[current]
        maxlen = current.len
      elif current.len == maxlen and current notin res:
        res.add current
      current.delete(0, idx)
    current.add c

  # Process the last current string.
  if current.len > maxlen: res = @[current]
  elif current.len == maxlen and current notin res: res.add current
  result = res.mapIt($it)


for str in ["xyzyabcybdfd", "xyzyab", "zzzzz", "a", "α⊆϶α϶", ""]:
  echo '"', str, '"', " → ", longestSubstrings(str)

echo "\nLongest substrings in concatenated list of words from “unixdict.txt”: ",
     longestSubstrings(toSeq("unixdict.txt".lines).join())
