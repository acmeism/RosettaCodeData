from numba import njit, prange
from numba.typed import List
import math

digits = "0123456789abcdef"
largestPrimeFactors = [1, 2, 3, 2, 5, 3, 7, 2, 3, 5, 11, 3, 13, 7, 5]

@njit
def toStringInBase(number: int, digits: str) -> str:
    base = len(digits)

    if number == 0:
        return "0"

    result = ""
    while number > 0:
        result = digits[number%base] + result
        number //= base
    return result

@njit
def allNonzeroDigitsPresent(s: str, base: int) -> bool:
    for i in range(1, base):
        digit = digits[i]
        found = False
        for ch in s:
            if ch == digit:
                found = True
                break
        if not found:
            return False
    return True

@njit(parallel=True)
def calculatePenholoSquare(start: int, end: int, div: int, r: int):
    n = (end - start) // div + 1
    numbers = [start + i * div for i in range(n)]
    isPenholo = [False] * n

    for i in prange(n):
        number = numbers[i]
        squareString = toStringInBase(number**2, digits[:r])
        if allNonzeroDigitsPresent(squareString, r):
            isPenholo[i] = True

    numberResults = List()
    squareResults = List()
    for i in range(n):
        if isPenholo[i]:
            numberString = toStringInBase(numbers[i], digits[:r])
            squareString = toStringInBase(numbers[i]**2, digits[:r])
            numberResults.append(numberString)
            squareResults.append(squareString)

    return numberResults, squareResults

for radix in range(2, 17):
    radixDigits = digits[1:radix]
    reversedDigits = radixDigits[::-1]

    min_ = int(math.ceil(math.sqrt(int(radixDigits, radix))))
    max_ = int(math.floor(math.sqrt(int(reversedDigits, radix))))
    divisor = largestPrimeFactors[radix-2]

    min_ += divisor - (min_ % divisor) if min_ % divisor != 0 else 0

    numbers, squares = calculatePenholoSquare(min_, max_, divisor, radix)
    penholo = list(numbers)
    penholoSquares = list(squares)

    print(f"There is a total of {len(penholo)} penholodigital squares in base {radix}:")
    if penholo:
        if radix <= 13:
            for numberString, square in zip(penholo, penholoSquares):
                print(f"{numberString}² = {square}")
        else:
            print(f"{penholo[0]}² = {penholoSquares[0]} ... {penholo[-1]}² = {penholoSquares[-1]}")
