def _notcell(c):
    return '0' if c == '1' else '1'

def eca_infinite(cells, rule):
    lencells = len(cells)
    rulebits = '{0:08b}'.format(rule)
    neighbours2next = {'{0:03b}'.format(n):rulebits[::-1][n] for n in range(8)}
    c = cells
    while True:
        yield c
        c = _notcell(c[0])*2 + c + _notcell(c[-1])*2    # Extend and pad the ends

        c = ''.join(neighbours2next[c[i-1:i+2]] for i in range(1,len(c) - 1))
        #yield c[1:-1]

if __name__ == '__main__':
    lines, start, rules = 20, '1', (90, 30, 122)
    zipped = [range(lines)] + [eca_infinite(start, rule) for rule in rules]
    print('\n   Rules: %r' % (rules,))
    for data in zip(*zipped):
        i = data[0]
        cells = ['%s%s%s' % (' '*(lines - i), c, ' '*(lines - i)) for c in data[1:]]
        print('%2i: %s' % (i, '    '.join(cells).replace('0', '.').replace('1', '#')))
