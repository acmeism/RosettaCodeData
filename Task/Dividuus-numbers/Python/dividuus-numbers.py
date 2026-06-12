from typing import List
import math

def digitalRoot(n: int) -> int:
    result: int = sum(map(int, str(n)))
    return result if result < 10 else digitalRoot(result)

def multiplicativeDigitalRoot(n: int) -> int:
    result: int = math.prod(map(int, str(n)))
    return result if result < 10 else multiplicativeDigitalRoot(result)

def isDividuus(n: int) -> bool:
    if not (
        digitalRoot(n) != 0
        and multiplicativeDigitalRoot(n) != 0
        and n % sum(map(int, str(n))) == 0
        and n % math.prod(map(int, str(n))) == 0
        and n % digitalRoot(n) == 0
        and n % multiplicativeDigitalRoot(n) == 0
    ):
        return False
    return True

if __name__ == "__main__":
    count: List[int] = []
    i: int = 1

    while len(count) < 50:
        if isDividuus(i):
            count.append(i)
        i += 1

    print("First fifty Dividuus numbers:")
    print(", ".join(map(str, count)))
    print()

    count.clear()
    for i in range(990_000_000, 1_000_000_001):
        if isDividuus(i):
            count.append(i)

    print("Dividuus numbers between 990,000,000 and 1,000,000,000:")
    print(", ".join(map(str, count)))
