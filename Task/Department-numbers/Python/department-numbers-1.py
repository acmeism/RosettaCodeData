from itertools import permutations

def solve():
    c, p, f, s = "\\,Police,Fire,Sanitation".split(',')
    print(f"{c:>3}  {p:^6} {f:^4} {s:^10}")
    c = 1
    for p, f, s in permutations(range(1, 8), r=3):
        if p + s + f == 12 and p % 2 == 0:
            print(f"{c:>3}: {p:^6} {f:^4} {s:^10}")
            c += 1

if __name__ == '__main__':
    solve()
