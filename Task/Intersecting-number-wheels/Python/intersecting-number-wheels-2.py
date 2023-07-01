def nextfrom(w, name):
    while True:
        nxt, w[name] = w[name][0], w[name][1:] + w[name][:1]
        if '0' <= nxt[0] <= '9':
            return nxt
        name = nxt

if __name__ == '__main__':
    for group in '''
A: 1 2 3
A: 1 B 2; B: 3 4
A: 1 D D; D: 6 7 8
A: 1 B C; B: 3 4; C: 5 B'''.strip().split('\n'):
        print(f"Intersecting Number Wheel group:\n  {group}")
        wheel, first = {}, None
        for w in group.strip().split(';'):
            name, *values = w.strip().split()
            wheel[name[:-1]] = values
            first = name[:-1] if first is None else first
        gen = ' '.join(nextfrom(wheel, first) for i in range(20))
        print(f"  Generates:\n    {gen} ...\n")
