""" Rosetta code task: Own_digits_power_sum """

def isowndigitspowersum(integer):
    """ true if sum of (digits of number raised to number of digits) == number """
    digits = [int(c) for c in str(integer)]
    exponent = len(digits)
    return sum(x ** exponent for x in digits) == integer

print("Own digits power sums for N = 3 to 9 inclusive:")
for i in range(100, 1000000000):
    if isowndigitspowersum(i):
        print(i)
