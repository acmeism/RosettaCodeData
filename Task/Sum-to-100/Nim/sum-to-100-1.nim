import algorithm, parseutils, sequtils, strutils, tables

type Expression = string

proc buildExprs(start: Natural = 0): seq[Expression] =
  let item = if start == 0: "" else: $start
  if start == 9: return @[item]
  for expr in buildExprs(start + 1):
    result.add item & expr
    result.add item & '-' & expr
    if start != 0: result.add item & '+' & expr

proc evaluate(expr: Expression): int =
  var idx = 0
  var val: int
  while idx < expr.len:
    let n = expr.parseInt(val, idx)
    inc idx, n
    result += val

let exprs = buildExprs()
var counts: CountTable[int]

echo "The solutions for 100 are:"
for expr in exprs:
  let sum = evaluate(expr)
  if sum == 100: echo expr
  if sum > 0: counts.inc(sum)

let (n, count) = counts.largest()
echo "\nThe maximum count of positive solutions is $1 for number $2.".format(count, n)

var s = 1
while true:
  if s notin counts:
    echo "\nThe smallest number than cannot be expressed is: $1.".format(s)
    break
  inc s

echo "\nThe ten highest numbers than can be expressed are:"
let numbers = sorted(toSeq(counts.keys), Descending)
echo numbers[0..9].join(", ")
