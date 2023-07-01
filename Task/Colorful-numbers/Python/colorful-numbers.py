from math import prod

largest = [0]

def iscolorful(n):
    if 0 <= n < 10:
        return True
    dig = [int(c) for c in str(n)]
    if 1 in dig or 0 in dig or len(dig) > len(set(dig)):
        return False
    products = list(set(dig))
    for i in range(len(dig)):
        for j in range(i+2, len(dig)+1):
            p = prod(dig[i:j])
            if p in products:
                return False
            products.append(p)

    largest[0] = max(n, largest[0])
    return True

print('Colorful numbers for 1:25, 26:50, 51:75, and 76:100:')
for i in range(1, 101, 25):
    for j in range(25):
        if iscolorful(i + j):
            print(f'{i + j: 5,}', end='')
    print()

csum = 0
for i in range(8):
    j = 0 if i == 0 else 10**i
    k = 10**(i+1) - 1
    n = sum(iscolorful(x) for x in range(j, k+1))
    csum += n
    print(f'The count of colorful numbers between {j} and {k} is {n}.')

print(f'The largest possible colorful number is {largest[0]}.')
print(f'The total number of colorful numbers is {csum}.')
