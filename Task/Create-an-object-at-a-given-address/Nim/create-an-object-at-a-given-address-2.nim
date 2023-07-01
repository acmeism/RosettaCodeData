var x: int = 3
var p: ptr int

p = cast[ptr int](addr(x))

echo "Before ", x
p[] = 5
echo "After: ", x
