from sympy.ntheory.generate import primorial
from sympy.ntheory import isprime

def fortunate_number(n):
    '''Return the fortunate number for positive integer n.'''
    # Since primorial(n) is even for all positive integers n,
    # it suffices to search for the fortunate numbers among odd integers.
    i = 3
    primorial_ = primorial(n)
    while True:
        if isprime(primorial_ + i):
            return i
        i += 2

fortunate_numbers = set()
for i in range(1, 76):
    fortunate_numbers.add(fortunate_number(i))

# Extract the first 50 numbers.
first50 = sorted(list(fortunate_numbers))[:50]

print('The first 50 fortunate numbers:')
print(('{:<3} ' * 10).format(*(first50[:10])))
print(('{:<3} ' * 10).format(*(first50[10:20])))
print(('{:<3} ' * 10).format(*(first50[20:30])))
print(('{:<3} ' * 10).format(*(first50[30:40])))
print(('{:<3} ' * 10).format(*(first50[40:])))
