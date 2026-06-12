import algorithm, math, sequtils, strutils

proc isPrime(n: int): bool =
    if n < 2: return false
    if n == 2: return true
    if n mod 2 == 0: return false
    let limit = int(sqrt(n.float))
    for i in countup(3, limit, 2):  # Only odd numbers
        if n mod i == 0:
            return false
    return true

let numbers = [2, 43, 81, 122, 63, 13, 7, 95, 103]
echo sorted(filter(numbers, proc (x: int): bool = isPrime(x))).join(", ")
