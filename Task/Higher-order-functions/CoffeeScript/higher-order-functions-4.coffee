double = (x) -> x*2
triple = (x) -> x*3
addOne = (x) -> x+1

addOne triple double 2 # same as addOne(triple(double(2)))
