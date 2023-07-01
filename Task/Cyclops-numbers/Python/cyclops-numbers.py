from sympy import isprime


def print50(a, width=8):
    for i, n in enumerate(a):
        print(f'{n: {width},}', end='\n' if (i + 1) % 10 == 0 else '')


def generate_cyclops(maxdig=9):
    yield 0
    for d in range((maxdig + 1) // 2):
        arr = [str(i) for i in range(10**d, 10**(d+1)) if not('0' in str(i))]
        for left in arr:
            for right in arr:
                yield int(left + '0' + right)


def generate_prime_cyclops():
    for c in generate_cyclops():
        if isprime(c):
            yield c


def generate_blind_prime_cyclops():
    for c in generate_prime_cyclops():
        cstr = str(c)
        mid = len(cstr) // 2
        if isprime(int(cstr[:mid] + cstr[mid+1:])):
            yield c


def generate_palindromic_cyclops(maxdig=9):
    for d in range((maxdig + 1) // 2):
        arr = [str(i) for i in range(10**d, 10**(d+1)) if not('0' in str(i))]
        for s in arr:
            yield int(s + '0' + s[::-1])


def generate_palindromic_prime_cyclops():
    for c in generate_palindromic_cyclops():
        if isprime(c):
            yield c


print('The first 50 cyclops numbers are:')
gen = generate_cyclops()
print50([next(gen) for _ in range(50)])
for i, c in enumerate(generate_cyclops()):
    if c > 10000000:
        print(
            f'\nThe next cyclops number after 10,000,000 is {c} at position {i:,}.')
        break

print('\nThe first 50 prime cyclops numbers are:')
gen = generate_prime_cyclops()
print50([next(gen) for _ in range(50)])
for i, c in enumerate(generate_prime_cyclops()):
    if c > 10000000:
        print(
            f'\nThe next prime cyclops number after 10,000,000 is {c} at position {i:,}.')
        break

print('\nThe first 50 blind prime cyclops numbers are:')
gen = generate_blind_prime_cyclops()
print50([next(gen) for _ in range(50)])
for i, c in enumerate(generate_blind_prime_cyclops()):
    if c > 10000000:
        print(
            f'\nThe next blind prime cyclops number after 10,000,000 is {c} at position {i:,}.')
        break

print('\nThe first 50 palindromic prime cyclops numbers are:')
gen = generate_palindromic_prime_cyclops()
print50([next(gen) for _ in range(50)], 11)
for i, c in enumerate(generate_palindromic_prime_cyclops()):
    if c > 10000000:
        print(
            f'\nThe next palindromic prime cyclops number after 10,000,000 is {c} at position {i}.')
        break
