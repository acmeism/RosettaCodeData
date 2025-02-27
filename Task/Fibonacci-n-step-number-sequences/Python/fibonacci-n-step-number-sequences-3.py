from itertools import islice, cycle

def fiblike(init_values=(0, 1)):
    tail = list(init_values)
    yield from tail
    for i in cycle(range(len(tail))):
        tail[i] = x = sum(tail)
        yield x

print([*islice(fiblike(), 10)])
lucas = fiblike([2, 1])
print([*islice(lucas, 10)])

suffixes = dict(enumerate('fibo tribo tetra penta hexa hepta octo nona deca'.split(), start=2))

for name, n in suffixes.items():
    fib = fiblike([1] + [2 ** i for i in range(n-1)])
    items = list(islice(fib, 15))
    print(f'n={n:>2}, {name:>5}nacci -> {items} ...')
