from functools import partial

def fs(f, s): return [f(value) for value in s]

def f1(value): return value * 2

def f2(value): return value ** 2

fsf1 = partial(fs, f1)
fsf2 = partial(fs, f2)

s = [0, 1, 2, 3]
assert fs(f1, s) == fsf1(s) # ==  [0, 2, 4, 6]
assert fs(f2, s) == fsf2(s) # ==  [0, 1, 4, 9]

s = [2, 4, 6, 8]
assert fs(f1, s) == fsf1(s) # ==  [4, 8, 12, 16]
assert fs(f2, s) == fsf2(s) # ==  [4, 16, 36, 64]
