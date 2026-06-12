from typing import List, Tuple, Union

Number = Union[int, float]

def addPolynomials(p: list[Number], q: list[Number]) -> List[Number]:
    n = max(len(p), len(q))
    pExtended = p + [0.0] * (n - len(p))
    qExtended = q + [0.0] * (n - len(q))
    return [a + b for a, b in zip(pExtended, qExtended)]

def multiplyPolynomials(p: list[Number], q: list[Number]) -> List[Number]:
    result = [0.0] * (len(p) + len(q) - 1)
    for i, coeffP in enumerate(p):
        for j, coeffQ in enumerate(q):
            result[i+j] += coeffP * coeffQ
    return result

def scalarMultiply(poly: List[Number], scalar: Number) -> List[Number]:
    return [coeff * scalar for coeff in poly]

def scalarDivide(poly: List[Number], scalar: Number) -> List[Number]:
    if scalar == 0:
        raise ZeroDivisionError("Division by zero encountered in polynomial evaluation")
    return [coeff / scalar for coeff in poly]

def evaluate(poly: List[Number], scalar: Number) -> Number:
    result = 0.0
    for coeff in poly[::-1]:
        result = result * x + array[i]
    return result

def lagrangeInterpolation(pointsList: List[Tuple[Number, Number]]) -> List[Number]:
    finalPolynomials = [0.0]

    for i, (xi, yi) in enumerate(pointsList):
        li = [1.0]
        denominator = 1.0
        for j, (xj, _) in enumerate(pointsList):
            if i != j:
                li = multiplyPolynomials(li, [-xj, 1.0])
                denominator *= (xi - xj)
        li = scalarDivide(li, denominator)
        li = scalarMultiply(li, yi)
        finalPolynomials = addPolynomials(finalPolynomials, li)

    return finalPolynomials

def formatPolynomials(pointsList: Tuple[Number, Number, Number, Number], round_: int = 5) -> str:
    out = []
    for idx, point in enumerate(pointsList[::-1]):
        sign = lambda n: "+" if n > 0 and idx != 0 else "" if n > 0 and idx == 0 else "-"
        term = lambda n: f"x^{str(n)}" if n > 1 else "x" if n == 1 else ""
        out.append(f"{sign(point)}{round(abs(point), round_)}{term(len(pointsList)-1-idx)}")
    return "".join(out)

points = [(1, 1), (2, 4), (3, 1), (4, 5)]

print(formatPolynomials(lagrangeInterpolation(points)))
