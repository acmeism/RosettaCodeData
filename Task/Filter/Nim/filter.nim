import sequtils

let values = toSeq(0..9)

# Filtering by returning a new sequence.
# - using an explicit filtering procedure.
echo "Even values: ", values.filter(proc(x: int): bool = x mod 2 == 0)
# - using a predicate.
echo "Odd values: ", values.filterIt(it mod 2 == 1)

# Filtering by modifying the sequence.
# - using an explicit filtering procedure.
var v1 = toSeq(0..9)
v1.keepIf(proc(x: int): bool = x mod 2 == 0)
echo "Even values: ", v1
# - using a predicate.
var v2 = toSeq(0..9)
v2.keepItIf(it mod 2 != 0)
echo "Odd values: ", v2
