from random import *

def qSort(a):
    if len(a) <= 1:
        return a
    else:
        q = choice(a)
        return qSort([elem for elem in a if elem < q]) + [q] * a.count(q) + qSort([elem for elem in a if elem > q])
