import strutils

proc count(s, sub): int =
  var i = 0
  while true:
    i = s.find(sub, i)
    if i < 0:
      break
    i += sub.len # i += 1 for overlapping substrings
    inc result

echo count("the three truths","th")

echo count("ababababab","abab")
