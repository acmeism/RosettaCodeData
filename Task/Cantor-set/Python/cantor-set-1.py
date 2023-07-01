WIDTH = 81
HEIGHT = 5

lines=[]
def cantor(start, len, index):
    seg = len / 3
    if seg == 0:
        return None
    for it in xrange(HEIGHT-index):
        i = index + it
        for jt in xrange(seg):
            j = start + seg + jt
            pos = i * WIDTH + j
            lines[pos] = ' '
    cantor(start,           seg, index + 1)
    cantor(start + seg * 2, seg, index + 1)
    return None

lines = ['*'] * (WIDTH*HEIGHT)
cantor(0, WIDTH, 1)

for i in xrange(HEIGHT):
    beg = WIDTH * i
    print ''.join(lines[beg : beg+WIDTH])
