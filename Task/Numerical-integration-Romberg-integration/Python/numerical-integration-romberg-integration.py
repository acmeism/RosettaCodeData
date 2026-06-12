from typing import Callable, Union, Tuple
import math

type Number = Union[int, float]

def rombergIntegration(
    func: Callable[[Number], Number],
    lower: Number,
    upper: Number,
    steps: int,
    accuracy: Number = 1e-8
) -> Tuple[Number, int]:
    h0 = upper - lower
    s0 = func(lower) + func(upper)
    r = [[0.0] * (steps + 1) for _ in range(steps+1)]
    r[0][0] = s0 * h0 / 2
    n = 1

    for i in range(1, steps+1):
        n *= 2
        h = h0 / n

        newSum = 0.0
        for j in range(1, n, 2):
            newSum += func(lower+j*h)

        r[i][0] = 0.5 * r[i-1][0] + newSum * h

        for k in range(1, i+1):
            factor = 4 ** k
            r[i][k] = (factor * r[i][k-1] - r[i-1][k-1]) / (factor - 1)

        if accuracy > 0 and abs(r[i][i] - r[i-1][i-1]) < accuracy:
            return r[i][i], i

    return r[steps][steps], steps

# Sanity checks
print(
    "▗▘1\n"
    f"▐   x dx = {rombergIntegration(lambda x: x, 0, 1, 10)[0]}\n"
    "▞ 0\n"
)
print(
    "▗▘1  2\n"
    f"▐   x  dx = {rombergIntegration(lambda x: x**2, 0, 1, 10)[0]}\n"
    "▞ 0\n"
)
print(
    "▗▘1   2\n"
    f"▐   3x +2x+1 dx = {rombergIntegration(lambda x: 3*x**2+2*x+1, 0, 1, 10)[0]}\n"
    "▞ 0\n"
)

# Final check
print(
    "Finally...\n\n"
    "▗▘3\n"
    f"▐    exp(x) dx = {rombergIntegration(math.exp, -3, 3, 5)[0]}\n"
    "▞ -3"
)
