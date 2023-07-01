N = 13

def method1(N=N):
    squares = [x**2 for x in range(0, N+1)]
    sqrset = set(squares)
    tri90, tri60, tri120 = (set() for _ in range(3))
    for a in range(1, N+1):
        a2 = squares[a]
        for b in range(1, a + 1):
            b2 = squares[b]
            c2 = a2 + b2
            if c2 in sqrset:
                tri90.add(tuple(sorted((a, b, int(c2**0.5)))))
            ab = a * b
            c2 -= ab
            if c2 in sqrset:
                tri60.add(tuple(sorted((a, b, int(c2**0.5)))))
            c2 += 2 * ab
            if c2 in sqrset:
                tri120.add(tuple(sorted((a, b, int(c2**0.5)))))
    return  sorted(tri90), sorted(tri60), sorted(tri120)
#%%
if __name__ == '__main__':
    print(f'Integer triangular triples for sides 1..{N}:')
    for angle, triples in zip([90, 60, 120], method1(N)):
        print(f'  {angle:3}° has {len(triples)} solutions:\n    {triples}')
    _, t60, _ = method1(10_000)
    notsame = sum(1 for a, b, c in t60 if a != b or b != c)
    print('Extra credit:', notsame)
