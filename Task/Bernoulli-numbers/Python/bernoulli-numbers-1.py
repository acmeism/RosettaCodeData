from fractions import Fraction as Fr

def bernoulli(n):
    A = [0] * (n+1)
    for m in range(n+1):
        A[m] = Fr(1, m+1)
        for j in range(m, 0, -1):
          A[j-1] = j*(A[j-1] - A[j])
    return A[0] # (which is Bn)

bn = [(i, bernoulli(i)) for i in range(61)]
bn = [(i, b) for i,b in bn if b]
width = max(len(str(b.numerator)) for i,b in bn)
for i,b in bn:
    print('B(%2i) = %*i/%i' % (i, width, b.numerator, b.denominator))
