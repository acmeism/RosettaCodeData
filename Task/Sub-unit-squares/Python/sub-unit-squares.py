# sub-unit_squares.py by Xing216
from gmpy2 import is_square
def digits(n: int) -> list[int]:
    return [int(d) for d in str(n)]
def get_sub_unit(digits_n: list[int], n: int) -> int:
    return int(''.join([str(d-1) for d in digits_n]))
def is_sub_unit_square(n: int) -> bool:
    if not is_square(n): return False
    digits_n = digits(n)
    if 0 in digits_n: return False
    sub_unit = get_sub_unit(digits_n, n)
    if len(str(sub_unit)) != len(str(n)): return False
    return is_square(sub_unit)
res = []
i = 1
while len(res) < 5:
    if is_sub_unit_square(i): res.append(i)
    i += 1
print(res)
