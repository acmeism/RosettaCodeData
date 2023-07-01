import math,sequtils,sugar,strformat
func root(x:float):seq[float] = @[sqrt(x),-sqrt(x)]
func asin(x:float):seq[float] = @[arcsin(x),arcsin(x)+TAU,arcsin(x)-TAU]
func format(x:float):seq[string] = @[&"{x:.2f}"]

#'bind' is a nim keyword, how about an infix operator instead
#our bind is the standard map+cat
func `-->`[T,U](input: openArray[T],f: T->seq[U]):seq[U] =
  input.map(f).concat

echo [0.5] --> root --> asin --> format
