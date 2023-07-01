""" Rosetta code task: Own_digits_power_sum (recursive method)"""

MAX_BASE = 10
POWER_DIGIT = [[1 for _ in range(MAX_BASE)] for _ in range(MAX_BASE)]
USED_DIGITS = [0 for _ in range(MAX_BASE)]
NUMBERS = []

def calc_num(depth, used):
    """ calculate the number at a given recurse depth """
    result = 0
    if depth < 3:
        return 0
    for i in range(1, MAX_BASE):
        if used[i] > 0:
            result += used[i] * POWER_DIGIT[depth][i]
    if result != 0:
        num, rnum = result, 1
        while rnum != 0:
            rnum = num // MAX_BASE
            used[num - rnum * MAX_BASE] -= 1
            num = rnum
            depth -= 1
        if depth == 0:
            i = 1
            while i < MAX_BASE and used[i] == 0:
                i += 1
            if i >= MAX_BASE:
                NUMBERS.append(result)
    return 0

def next_digit(dgt, depth):
    """ get next digit at the given depth """
    if depth < MAX_BASE - 1:
        for i in range(dgt, MAX_BASE):
            USED_DIGITS[dgt] += 1
            next_digit(i, depth + 1)
            USED_DIGITS[dgt] -= 1

    if dgt == 0:
        dgt = 1
    for i in range(dgt, MAX_BASE):
        USED_DIGITS[i] += 1
        calc_num(depth, USED_DIGITS.copy())
        USED_DIGITS[i] -= 1

for j in range(1, MAX_BASE):
    for k in range(MAX_BASE):
        POWER_DIGIT[j][k] = POWER_DIGIT[j - 1][k] * k

next_digit(0, 0)
print(NUMBERS)
NUMBERS = list(set(NUMBERS))
NUMBERS.sort()
print('Own digits power sums for N = 3 to 9 inclusive:')
for n in NUMBERS:
    print(n)
