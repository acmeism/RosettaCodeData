import strutils, rdstdin

var
  w = readLineFromStdin("Width: ").parseInt()
  h = readLineFromStdin("Height: ").parseInt()
  s = newSeq[seq[int]](h)

for i in 0 .. < h:
  s[i].newSeq(w)
