import strutils, rdstdin

let
  w = readLineFromStdin("Width: ").parseInt()
  h = readLineFromStdin("Height: ").parseInt()

# Create the rows.
var s = newSeq[seq[int]](h)

# Create the columns.
for i in 0 ..< h:
  s[i].newSeq(w)

# Store a value in an element.
s[0][0] = 5

# Retrieve and print it.
echo s[0][0]

# The allocated memory is freed by the garbage collector.
