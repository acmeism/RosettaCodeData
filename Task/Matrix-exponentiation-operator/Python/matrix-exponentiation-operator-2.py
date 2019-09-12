class Mat(list) :
    def __matmul__(self, B) :
        A = self
        return Mat([[sum(A[i][k]*B[k][j] for k in range(len(B)))
                    for j in range(len(B[0])) ] for i in range(len(A))])


def identity(size):
    size = range(size)
    return [[(i==j)*1 for i in size] for j in size]

def power(F, n):
    result = Mat(identity(len(F)))
    b = Mat(F)
    while n > 0:
        if (n%2) == 0:
            b = b @ b
            n //= 2
        else:
            result = b @ result
            b = b @ b
            n //= 2
    return result

def printtable(data):
    for row in data:
        print (' '.join('%-5s' % ('%s' % cell) for cell in row))

m = [[3,2], [2,1]]
for i in range(5):
    print('\n%i:' % i)
    printtable(power(m, i))
