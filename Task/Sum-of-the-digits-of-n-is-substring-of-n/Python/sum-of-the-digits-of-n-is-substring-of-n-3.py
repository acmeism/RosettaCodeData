'''Sum of the digits of n is substring of n'''

# Here is a one-liner version for education
# Elegant once you lean on list comprehensions and library functions.
#
print([n for n in range(0, 1000) if str(sum(map(int, str(n)))) in str(n) ])
