import algorithm
import tables
import times

var anagrams: Table[seq[char], seq[string]]  # Mapping sorted_list_of chars -> list of anagrams.

#---------------------------------------------------------------------------------------------------

func deranged(s1, s2: string): bool =
  ## Return true if "s1" and "s2" are deranged anagrams.

  for i, c in s1:
    if s2[i] == c:
      return false
  result = true

#---------------------------------------------------------------------------------------------------

let t0 = getTime()

# Build the anagrams table.
for word in lines("unixdict.txt"):
  anagrams.mgetOrPut(sorted(word), @[]).add(word)

# Find the longest deranged anagrams.
var bestLen = 0
var best1, best2: string
for (key, list) in anagrams.pairs:
  if key.len > bestLen:
    var s1 = list[0]
    for i in 1..list.high:
      let s2 = list[i]
      if deranged(s1, s2):
        # Found a better pair.
        best1 = s1
        best2 = s2
        bestLen = s1.len
        break

echo "Longest deranged anagram pair: ", best1, " ", best2
echo "Processing time: ", (getTime() - t0).inMilliseconds, " ms."
