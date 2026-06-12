import std/[strformat, strutils]

const Elements = 10_000_000
type KlarnerRado = array[1..Elements, int]

proc initKlarnerRado(): KlarnerRado =
  var i2, i3 = 1
  var m2, m3 = 1
  for i in 1..result.high:
    let m = min(m2, m3)
    result[i] = m
    if m2 == m:
      m2 = result[i2].int shl 1 or 1
      inc i2
    if m3 == m:
      m3 = result[i3].int * 3 + 1
      inc i3

let klarnerRado = initKlarnerRado()

echo "First 100 elements of the Klarner-Rado sequence:"
for i in 1..100:
  stdout.write &"{klarnerRado[i]:>3}"
  stdout.write if i mod 10 == 0: '\n' else: ' '
echo()

var i = 1000
while i <= Elements:
  echo &"The {insertSep($i)}th element of Klarner-Rado sequence is {insertSep($klarnerRado[i])}"
  i *= 10
