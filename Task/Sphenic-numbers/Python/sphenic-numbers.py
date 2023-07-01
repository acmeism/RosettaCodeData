""" rosettacode.org task Sphenic_numbers """


from sympy import factorint

sphenics1m, sphenic_triplets1m = [], []

for i in range(3, 1_000_000):
    d = factorint(i)
    if len(d) == 3 and sum(d.values()) == 3:
        sphenics1m.append(i)
        if len(sphenics1m) > 2 and i - sphenics1m[-3] == 2 and i - sphenics1m[-2] == 1:
            sphenic_triplets1m.append(i)

print('Sphenic numbers less than 1000:')
for i, n in enumerate(sphenics1m):
    if n < 1000:
        print(f'{n : 5}', end='\n' if (i + 1) % 15 == 0 else '')
    else:
        break

print('\n\nSphenic triplets less than 10_000:')
for i, n in enumerate(sphenic_triplets1m):
    if n < 10_000:
        print(f'({n - 2} {n - 1} {n})', end='\n' if (i + 1) % 3 == 0 else '  ')
    else:
        break

print('\nThere are', len(sphenics1m), 'sphenic numbers and', len(sphenic_triplets1m),
      'sphenic triplets less than 1 million.')

S2HK = sphenics1m[200_000 - 1]
T5K = sphenic_triplets1m[5000 - 1]
print(f'The 200_000th sphenic number is {S2HK}, with prime factors {list(factorint(S2HK).keys())}.')
print(f'The 5000th sphenic triplet is ({T5K - 2} {T5K - 1} {T5K}).')
