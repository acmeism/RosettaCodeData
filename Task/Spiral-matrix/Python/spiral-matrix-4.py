import itertools

concat = itertools.chain.from_iterable
def partial_sums(items):
    s = 0
    for x in items:
        s += x
        yield s

grade = lambda xs: sorted(range(len(xs)), key=xs.__getitem__)
values = lambda n: itertools.cycle([1,n,-1,-n])
counts = lambda n: concat([i,i-1] for i in range(n,0,-1))
reshape = lambda n, xs: zip(*([iter(xs)] * n))

spiral = lambda n: reshape(n, grade(list(partial_sums(concat(
                       [v]*c for c,v in zip(counts(n), values(n)))))))

for row in spiral(5):
    print(' '.join('%3s' % x for x in row))
