import math

proc isPerfect(n: int): bool =
    var sum: int = 1
    for i in 2 .. <(n.toFloat.sqrt+1).toInt:
        if n mod i == 0:
            sum += (i + n div i)
    return (n == sum)

for i in 2..10_000:
    if isPerfect(i):
        echo(i)
