# -*- coding: utf-8 -*-
import operator
from itertools import product, permutations

def mydiv(n, d):
    return n / d if d != 0 else 9999999

syms = [operator.add, operator.sub, operator.mul, mydiv]
op = {sym: ch for sym, ch in zip(syms, '+-*/')}

def solve24(nums):
    for x, y, z in product(syms, repeat=3):
        for a, b, c, d in permutations(nums):
            if round(x(y(a,b),z(c,d)),5) == 24:
                return f"({a} {op[y]} {b}) {op[x]} ({c} {op[z]} {d})"
            elif round(x(a,y(b,z(c,d))),5) == 24:
                return f"{a} {op[x]} ({b} {op[y]} ({c} {op[z]} {d}))"
            elif round(x(y(z(c,d),b),a),5) == 24:
                return f"(({c} {op[z]} {d}) {op[y]} {b}) {op[x]} {a}"
            elif round(x(y(b,z(c,d)),a),5) == 24:
                return f"({b} {op[y]} ({c} {op[z]} {d})) {op[x]} {a}"
    return '--Not Found--'

if __name__ == '__main__':
    #nums = eval(input('Four integers in the range 1:9 inclusive, separated by commas: '))
    for nums in [
        [9,4,4,5],
        [1,7,2,7],
        [5,7,5,4],
        [1,4,6,6],
        [2,3,7,3],
        [8,7,9,7],
        [1,6,2,6],
        [7,9,4,1],
        [6,4,2,2],
        [5,7,9,7],
        [3,3,8,8],  # Difficult case requiring precise division
            ]:
        print(f"solve24({nums}) -> {solve24(nums)}")
