import itertools

def riseEqFall(num):
    """Check whether a number belongs to sequence A296712."""
    height = 0
    d1 = num % 10
    num //= 10
    while num:
        d2 = num % 10
        height += (d1<d2) - (d1>d2)
        d1 = d2
        num //= 10
    return height == 0

def sequence(start, fn):
    """Generate a sequence defined by a function"""
    num=start-1
    while True:
        num += 1
        while not fn(num): num += 1
        yield num

a296712 = sequence(1, riseEqFall)

# Generate the first 200 numbers
print("The first 200 numbers are:")
print(*itertools.islice(a296712, 200))

# Generate the 10,000,000th number
print("The 10,000,000th number is:")
print(*itertools.islice(a296712, 10000000-200-1, 10000000-200))
# It is necessary to subtract 200 from the index, because 200 numbers
# have already been consumed.
