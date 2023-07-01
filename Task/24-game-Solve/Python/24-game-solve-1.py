# -*- coding: utf-8 -*-
# Python 3
from operator import mul, sub, add


def div(a, b):
    if b == 0:
        return 999999.0
    return a / b

ops = {mul: '*', div: '/', sub: '-', add: '+'}

def solve24(num, how, target):
    if len(num) == 1:
        if round(num[0], 5) == round(target, 5):
            yield str(how[0]).replace(',', '').replace("'", '')
    else:
        for i, n1 in enumerate(num):
            for j, n2 in enumerate(num):
                if i != j:
                    for op in ops:
                        new_num = [n for k, n in enumerate(num) if k != i and k != j] + [op(n1, n2)]
                        new_how = [h for k, h in enumerate(how) if k != i and k != j] + [(how[i], ops[op], how[j])]
                        yield from solve24(new_num, new_how, target)

tests = [
         [1, 7, 2, 7],
         [5, 7, 5, 4],
         [1, 4, 6, 6],
         [2, 3, 7, 3],
         [1, 6, 2, 6],
         [7, 9, 4, 1],
         [6, 4, 2, 2],
         [5, 7, 9, 7],
         [3, 3, 8, 8],  # Difficult case requiring precise division
         [8, 7, 9, 7],  # No solution
         [9, 4, 4, 5],  # No solution
            ]
for nums in tests:
    print(nums, end=' : ')
    try:
        print(next(solve24(nums, nums, 24)))
    except StopIteration:
        print("No solution found")
