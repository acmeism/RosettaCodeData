try:
    from functools import reduce
except:
    pass

def mdroot(n):
    'Multiplicative digital root'
    mdr = [n]
    while mdr[-1] > 9:
        mdr.append(reduce(int.__mul__, (int(dig) for dig in str(mdr[-1])), 1))
    return len(mdr) - 1, mdr[-1]

if __name__ == '__main__':
    print('Number: (MP, MDR)\n======  =========')
    for n in (123321, 7739, 893, 899998):
        print('%6i: %r' % (n, mdroot(n)))

    table, n = {i: [] for i in range(10)}, 0
    while min(len(row) for row in table.values()) < 5:
        mpersistence, mdr = mdroot(n)
        table[mdr].append(n)
        n += 1
    print('\nMP: [n0..n4]\n==  ========')
    for mp, val in sorted(table.items()):
        print('%2i: %r' % (mp, val[:5]))
