def eca(cells, rule):
    lencells = len(cells)
    c = "0" + cells + "0"    # Zero pad the ends
    rulebits = '{0:08b}'.format(rule)
    neighbours2next = {'{0:03b}'.format(n):rulebits[::-1][n] for n in range(8)}
    yield c[1:-1]
    while True:
        c = ''.join(['0',
                     ''.join(neighbours2next[c[i-1:i+2]]
                             for i in range(1,lencells+1)),
                     '0'])
        yield c[1:-1]

if __name__ == '__main__':
    lines, start, rules = 50, '0000000001000000000', (90, 30, 122)
    zipped = [range(lines)] + [eca(start, rule) for rule in rules]
    print('\n   Rules: %r' % (rules,))
    for data in zip(*zipped):
        i = data[0]
        cells = data[1:]
        print('%2i: %s' % (i, '    '.join(cells).replace('0', '.').replace('1', '#')))
