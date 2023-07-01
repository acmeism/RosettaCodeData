def ludic():
    yield 1
    ludics = []
    while True:
        k = 0
        for j in reversed(ludics):
            k = (k*j)//(j-1) + 1
        ludics.append(k+2)
        yield k+2
def triplets():
    a, b, c, d = 0, 0, 0, 0
    for k in ludic():
        if k-4 in (b, c, d) and k-6 in (a, b, c):
            yield k-6, k-4, k
        a, b, c, d = b, c, d, k

first_25 = [k for i, k in zip(range(25), gen_ludic())]
print(f'First 25 ludic numbers: {first_25}')
count = 0
for k in gen_ludic():
    if k > 1000:
        break
    count += 1
print(f'Number of ludic numbers <= 1000: {count}')
it = iter(gen_ludic())
for i in range(1999):
    next(it)
ludic2000 = [next(it) for i in range(6)]
print(f'Ludic numbers 2000..2005: {ludic2000}')

print('Ludic triplets < 250:')
for a, b, c in triplets():
    if c >= 250:
        break
    print(f'[{a}, {b}, {c}]')
