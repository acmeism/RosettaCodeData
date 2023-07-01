from sympy import divisors

numfound = 0
for num in range(1, 1_000_000):
    if num == 1 or len(divisors(num)) == 8:
        numfound += 1
        if numfound <= 50:
            print(f'{num:5}', end='\n' if numfound % 10 == 0 else '')
        if numfound == 500:
            print(f'\nFive hundreth: {num:,}')
        if numfound == 5000:
            print(f'\nFive thousandth: {num:,}')
        if numfound == 50000:
            print(f'\nFifty thousandth: {num:,}')
            break
