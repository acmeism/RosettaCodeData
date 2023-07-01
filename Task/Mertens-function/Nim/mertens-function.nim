import sequtils, strformat

func mertensNumbers(max: int): seq[int] =
  result = repeat(1, max + 1)
  for n in 2..max:
    for k in 2..n:
      dec result[n], result[n div k]

const Max = 1000
let mertens = mertensNumbers(Max)

echo "First 199 Mertens numbers:"
const Count = 200
var column = 0
for i in 0..<Count:
  if column > 0: stdout.write ' '
  stdout.write if i == 0: "  " else: &"{mertens[i]:>2}"
  inc column
  if column == 20:
    stdout.write '\n'
    column = 0

var zero, cross, previous = 0
for i in 1..Max:
  let m = mertens[i]
  if m == 0:
    inc zero
    if previous != 0:
      inc cross
  previous = m

echo ""
echo &"M(n) is zero {zero} times for 1 ⩽ n ⩽ {Max}."
echo &"M(n) crosses zero {cross} times for 1 ⩽ n ⩽ {Max}."
