# Define the sum of proper divisors function
def sum_of_proper_divisors(n):
    return sum(divisors(n)) - n

# Iterate over the desired range
for x in range(1, 20001):
    y = sum_of_proper_divisors(x)
    if y > x:
        if x == sum_of_proper_divisors(y):
            print(f"{x} {y}")
