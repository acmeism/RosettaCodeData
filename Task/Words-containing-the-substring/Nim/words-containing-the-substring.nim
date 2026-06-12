import strutils

var count = 0
for word in "unixdict.txt".lines:
  if word.len > 11 and word.contains("the"):
    inc count
    echo ($count).align(2), ' ', word
