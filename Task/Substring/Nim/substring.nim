import strformat, strutils, unicode

let
  s1 = "abcdefgh"   # ASCII string.
  s2 = "àbĉdéfgĥ"   # UTF-8 string.
  n = 2
  m = 3
  c = 'd'
  cs1 = "de"
  cs2 = "dé"

var pos: int

# ASCII strings.
# We can take a substring using "s.substr(first, last)" or "s[first..last]".
# The latter form can also be used as value to assign a substring.

echo "ASCII string: ", s1

echo &"Starting from n = {n} characters in and of m = {m} length: ", s1[(n - 1)..(n + m - 2)]
echo &"Starting from n = {n} characters in, up to the end of the string: ", s1[(n - 1)..^1]
echo "Whole string minus the last character: ", s1[0..^2]

pos = s1.find(c)
if pos > 0:
  echo &"Starting from character '{c}' within the string and of m = {m} length: ", s1[pos..<(pos + m)]
else:
  echo &"Character '{c}' not found."

pos = s1.find(cs1)
if pos > 0:
  echo &"Starting from substring “{cs1}” within the string and of m = {m} length: ", s1[pos..<(pos + m)]
else:
  echo &"String “{cs1}” not found."


# UTF-8 strings.

proc findUtf8(s: string; c: char): int =
  ## Return the codepoint index of the first occurrence of a given character in a string.
  ## Return - 1 if not found.
  s.toRunes.find(Rune(c))

proc findUtf8(s1, s2: string): int =
  ## Return the codepoint index of the first occurrence of a given string in a string.
  ## Return - 1 if not found.
  let s1 = s1.toRunes
  let s2 = s2.toRunes
  for i in 0..(s1.len - s2.len):
    if s1[i..(i + s2.len - 1)] == s2: return i
  result = -1

echo()
echo "UTF-8 string: ", s2

echo &"Starting from n = {n} characters in and of m = {m} length: ", s2.runeSubStr(n - 1, m)
echo &"Starting from n = {n} characters in, up to the end of the string: ", s2.runeSubstr(n - 1)
echo "Whole string minus the last character: ", s2.runeSubStr(0, s2.runeLen - 1)

pos = s2.findUtf8(c)
if pos > 0:
  echo &"Starting from character '{c}' within the string and of m = {m} length: ", s2.runeSubStr(pos, m)
else:
  echo &"String “{cs1}” not found."

pos = s2.findUtf8(cs2)
if pos > 0:
  echo &"Starting from substring “{cs2}” within the string and of m = {m} length: ", s2.runeSubStr(pos, m)
else:
  echo &"String “{cs2}” not found."
