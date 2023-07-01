def conjugate_transpose(m):
    return tuple(tuple(n.conjugate() for n in row) for row in zip(*m))

def mmul( ma, mb):
    return tuple(tuple(sum( ea*eb for ea,eb in zip(a,b)) for b in zip(*mb)) for a in ma)

def mi(size):
    'Complex Identity matrix'
    sz = range(size)
    m = [[0 + 0j for i in sz] for j in sz]
    for i in range(size):
        m[i][i] = 1 + 0j
    return tuple(tuple(row) for row in m)

def __allsame(vector):
    first, rest = vector[0], vector[1:]
    return all(i == first for i in rest)

def __allnearsame(vector, eps=1e-14):
    first, rest = vector[0], vector[1:]
    return all(abs(first.real - i.real) < eps and abs(first.imag - i.imag) < eps
               for i in rest)

def isequal(matrices, eps=1e-14):
    'Check any number of matrices for equality within eps'
    x = [len(m) for m in matrices]
    if not __allsame(x): return False
    y = [len(m[0]) for m in matrices]
    if not __allsame(y): return False
    for s in range(x[0]):
        for t in range(y[0]):
            if not __allnearsame([m[s][t] for m in matrices], eps): return False
    return True


def ishermitian(m, ct):
    return isequal([m, ct])

def isnormal(m, ct):
    return isequal([mmul(m, ct), mmul(ct, m)])

def isunitary(m, ct):
    mct, ctm = mmul(m, ct), mmul(ct, m)
    mctx, mcty, cmx, ctmy = len(mct), len(mct[0]), len(ctm), len(ctm[0])
    ident = mi(mctx)
    return isequal([mct, ctm, ident])

def printm(comment, m):
    print(comment)
    fields = [['%g%+gj' % (f.real, f.imag) for f in row] for row in m]
    width = max(max(len(f) for f in row) for row in fields)
    lines = (', '.join('%*s' % (width, f) for f in row) for row in fields)
    print('\n'.join(lines))

if __name__ == '__main__':
    for matrix in [
            ((( 3.000+0.000j), (+2.000+1.000j)),
            (( 2.000-1.000j), (+1.000+0.000j))),

            ((( 1.000+0.000j), (+1.000+0.000j), (+0.000+0.000j)),
            (( 0.000+0.000j), (+1.000+0.000j), (+1.000+0.000j)),
            (( 1.000+0.000j), (+0.000+0.000j), (+1.000+0.000j))),

            ((( 2**0.5/2+0.000j), (+2**0.5/2+0.000j), (+0.000+0.000j)),
            (( 0.000+2**0.5/2j), (+0.000-2**0.5/2j), (+0.000+0.000j)),
            (( 0.000+0.000j), (+0.000+0.000j), (+0.000+1.000j)))]:
        printm('\nMatrix:', matrix)
        ct = conjugate_transpose(matrix)
        printm('Its conjugate transpose:', ct)
        print('Hermitian? %s.' % ishermitian(matrix, ct))
        print('Normal?    %s.' % isnormal(matrix, ct))
        print('Unitary?   %s.' % isunitary(matrix, ct))
