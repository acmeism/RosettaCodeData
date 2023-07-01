def eca_wrap(cells, rule):
    lencells = len(cells)
    rulebits = '{0:08b}'.format(rule)
    neighbours2next = {tuple('{0:03b}'.format(n)):rulebits[::-1][n] for n in range(8)}
    c = cells
    while True:
        yield c
        c = ''.join(neighbours2next[(c[i-1], c[i], c[(i+1) % lencells])] for i in range(lencells))

if __name__ == '__main__':
    lines, start, rules = 50, '0000000001000000000', (90, 30, 122)
    zipped = [range(lines)] + [eca_wrap(start, rule) for rule in rules]
    print('\n   Rules: %r' % (rules,))
    for data in zip(*zipped):
        i = data[0]
        cells = data[1:]
        print('%2i: %s' % (i, '    '.join(cells).replace('0', '.').replace('1', '#')))
