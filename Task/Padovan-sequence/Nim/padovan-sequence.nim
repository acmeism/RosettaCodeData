import sequtils, strutils, tables

const
  P = 1.324717957244746025960908854
  S = 1.0453567932525329623

  Rules = {'A': "B", 'B': "C", 'C': "AB"}.toTable


iterator padovan1(n: Natural): int {.closure.} =
  ## Yield the first "n" Padovan values using recurrence relation.
  for _ in 1..min(n, 3): yield 1
  var a, b, c = 1
  var count = 3
  while count < n:
    (a, b, c) = (b, c, a + b)
    yield c
    inc count


iterator padovan2(n: Natural): int {.closure.} =
  ## Yield the first "n" Padovan values using formula.
  if n > 1: yield 1
  var p = 1.0
  var count = 1
  while count < n:
    yield (p / S).toInt
    p *= P
    inc count


iterator padovan3(n: Natural): string {.closure.} =
  ## Yield the strings produced by the L-system.
  var s = "A"
  var count = 0
  while count < n:
    yield s
    var next: string
    for ch in s:
      next.add Rules[ch]
    s = move(next)
    inc count


echo "First 20 terms of the Padovan sequence:"
echo toSeq(padovan1(20)).join(" ")

let list1 = toSeq(padovan1(64))
let list2 = toSeq(padovan2(64))
echo "The first 64 iterative and calculated values ",
     if list1 == list2: "are the same." else: "differ."

echo ""
echo "First 10 L-system strings:"
echo toSeq(padovan3(10)).join(" ")
echo ""
echo "Lengths of the 32 first L-system strings:"
let list3 = toSeq(padovan3(32)).mapIt(it.len)
echo list3.join(" ")
echo "These lengths are",
     if list3 == list1[0..31]: " " else: " not ",
     "the 32 first terms of the Padovan sequence."
