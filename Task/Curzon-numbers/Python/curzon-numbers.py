def is_Curzon(n, k):
    r = k * n
    return pow(k, n, r + 1) == r

for k in [2, 4, 6, 8, 10]:
    n, curzons = 1, []
    while len(curzons) < 1000:
        if is_Curzon(n, k):
            curzons.append(n)
        n += 1
    print(f'Curzon numbers with k = {k}:')
    for i, c in enumerate(curzons[:50]):
        print(f'{c: 5,}', end='\n' if (i + 1) % 25 == 0 else '')
    print(f'    Thousandth Curzon with k = {k}: {curzons[999]}.\n')
