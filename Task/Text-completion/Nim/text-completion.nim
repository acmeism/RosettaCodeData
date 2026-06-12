import std/editdistance, sequtils, strformat, strutils

let search = "complition"
let words = toSeq("unixdict.txt".lines)
var lev: array[4, seq[string]]
for word in words:
  let ld = editDistance(search, word)
  if ld < 4:
    lev[ld].add word
echo &"Input word: {search}\n"
let length = float(search.len)
for i in 0..3:
  if lev[i].len == 0: continue  # No result.
  let similarity = (length - float(i)) * 100 / length
  echo &"Words which are {similarity:4.1f}% similar:"
  echo lev[i].join(" ")
  echo()
