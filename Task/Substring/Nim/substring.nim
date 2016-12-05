import strutils

let
  s = "abcdefgh"
  n = 2
  m = 3
  c = 'd'
  cs = "cd"
var i = 0

# starting from n=2 characters in and m=3 in length
echo s[n-1 .. n+m-2]

# starting from n characters in, up to the end of the string
echo s[n-1 .. s.high]

# whole string minus last character:
echo s[0 .. <s.high]

# starting from a known character c='d'within the string and of m length
i = s.find(c)
echo s[i .. <i+m]

# starting from a known substring cs="cd" within the string and of m length
i = s.find(cs)
echo s[i .. <i+m]
