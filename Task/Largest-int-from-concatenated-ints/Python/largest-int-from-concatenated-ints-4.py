from itertools import permutations
def maxnum(x):
    return max(int(''.join(n) for n in permutations(str(i) for i in x)))

for numbers in [(1, 34, 3, 98, 9, 76, 45, 4), (54, 546, 548, 60)]:
    print('Numbers: %r\n  Largest integer: %15s' % (numbers, maxnum(numbers)))
