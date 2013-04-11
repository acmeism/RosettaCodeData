def qsort(L):
    return (qsort([y for y in L[1:] if y <  L[0]]) +
            L[:1] +
            qsort([y for y in L[1:] if y >= L[0]])) if len(L) > 1 else L
