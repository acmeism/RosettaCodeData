def mc_rank(iterable, start=1):
    """Modified competition ranking"""
    lastresult, fifo = None, []
    for n, item in enumerate(iterable, start-1):
        if item[0] == lastresult:
            fifo += [item]
        else:
            while fifo:
                yield n, fifo.pop(0)
            lastresult, fifo = item[0], fifo + [item]
    while fifo:
        yield n+1, fifo.pop(0)


def sc_rank(iterable, start=1):
    """Standard competition ranking"""
    lastresult, lastrank = None, None
    for n, item in enumerate(iterable, start):
        if item[0] == lastresult:
            yield lastrank, item
        else:
            yield n, item
            lastresult, lastrank = item[0], n


def d_rank(iterable, start=1):
    """Dense ranking"""
    lastresult, lastrank = None, start - 1,
    for item in iterable:
        if item[0] == lastresult:
            yield lastrank, item
        else:
            lastresult, lastrank = item[0], lastrank + 1
            yield lastrank, item


def o_rank(iterable, start=1):
    """Ordinal  ranking"""
    yield from enumerate(iterable, start)


def f_rank(iterable, start=1):
    """Fractional ranking"""
    last, fifo = None, []
    for n, item in enumerate(iterable, start):
        if item[0] != last:
            if fifo:
                mean = sum(f[0] for f in fifo) / len(fifo)
                while fifo:
                    yield mean, fifo.pop(0)[1]
        last = item[0]
        fifo.append((n, item))
    if fifo:
        mean = sum(f[0] for f in fifo) / len(fifo)
        while fifo:
            yield mean, fifo.pop(0)[1]


if __name__ == '__main__':
    scores = [(44, 'Solomon'),
              (42, 'Jason'),
              (42, 'Errol'),
              (41, 'Garry'),
              (41, 'Bernard'),
              (41, 'Barry'),
              (39, 'Stephen')]

    print('\nScores to be ranked (best first):')
    for s in scores:
        print('        %2i %s' % (s ))
    for ranker in [sc_rank, mc_rank, d_rank, o_rank, f_rank]:
        print('\n%s:' % ranker.__doc__)
        for rank, score in ranker(scores):
            print('  %3g, %r' % (rank, score))
