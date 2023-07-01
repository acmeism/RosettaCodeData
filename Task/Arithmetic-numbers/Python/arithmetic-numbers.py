def factors(n: int):
    f = set([1, n])
    i = 2
    while True:
        j = n // i
        if j < i:
            break
        if i * j == n:
            f.add(i)
            f.add(j)
        i += 1
    return f

arithmetic_count = 0
composite_count = 0
n = 1
while arithmetic_count <= 1000000:
    f = factors(n)
    if (sum(f)/len(f)).is_integer():
        arithmetic_count += 1
        if len(f) > 2:
            composite_count += 1
        if arithmetic_count <= 100:
            print(f'{n:3d} ', end='')
            if arithmetic_count % 10 == 0:
                print()
        if arithmetic_count in (1000, 10000, 100000, 1000000):
            print(f'\n{arithmetic_count}th arithmetic number is {n}')
            print(f'Number of composite arithmetic numbers <= {n}: {composite_count}')
    n += 1
