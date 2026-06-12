# Print the first group of 3 characters
# within a string where all 3 pairs
# of their ord-code differences is a prime.

from itertools import combinations
import math

def a(a,b):
    return abs(a-b)

def is_prime(i):
    if i < 2: return False
    for n in range(2,i-1):
        if i % n == 0: return False
    return True

class Run:
    def __init__(self,tests,n):
        self.tests = tests
        self.number = n

    def diffs(self,s):
        L = list(map(ord,s))
        D = map(lambda x:a(x[0],x[1]),combinations(L,2))
        c = 0
        for i in D:
            if is_prime(i):
                c += 1
        return c == math.comb(self.number,2)

    def run_tests(self):
        for x in self.tests:
            comb = [''.join(i) for i in combinations(x, self.number)]
            for i in comb:
                if self.diffs(i):
                    print(i)
                    break
            else:
                print("Not found.")

tests = ['riOtjuoq', 'wjtiOxtj', 'akwercjoeiJ', 'Weej', 'Aek', 'jjgja']

runner = Run(tests, 3)
runner.run_tests()

print ('======')

runner = Run(tests, 2)
runner.run_tests()

