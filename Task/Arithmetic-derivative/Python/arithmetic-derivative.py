from sympy.ntheory import factorint

def D(n):
    if n < 0:
        return -D(-n)
    elif n < 2:
        return 0
    else:
        fdict = factorint(n)
        if len(fdict) == 1 and 1 in fdict: # is prime
            return 1
        return sum([n * e // p for p, e in fdict.items()])

for n in range(-99, 101):
    print('{:5}'.format(D(n)), end='\n' if n % 10 == 0 else '')

print()
for m in range(1, 21):
    print('(D for 10**{}) divided by 7 is {}'.format(m, D(10 ** m) // 7))
