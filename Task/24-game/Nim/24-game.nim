from random import randomize, rand
from strutils import Whitespace
from algorithm import sort
from sequtils import newSeqWith

randomize()

var
  problem = newSeqWith(4, rand(1..9))
  stack: seq[float]
  digits: seq[int]

echo "Make 24 with the digits: ", problem

template op(c: untyped) =
  let a = stack.pop
  stack.add c(stack.pop, a)

for c in stdin.readLine:
  case c
  of '1'..'9':
    digits.add c.ord - '0'.ord
    stack.add float(c.ord - '0'.ord)
  of '+': op `+`
  of '*': op `*`
  of '-': op `-`
  of '/': op `/`
  of Whitespace: discard
  else: raise newException(ValueError, "Wrong char: " & c)

sort digits
sort problem
if digits != problem:
  raise newException(ValueError, "Not using the given digits.")
if stack.len != 1:
  raise newException(ValueError, "Wrong expression.")
echo "Result: ", stack[0]
echo if abs(stack[0] - 24) < 0.001: "Good job!" else: "Try again."
