def insertion_sort(L):
    for i in xrange(1, len(L)):
        j = i-1
        key = L[i]
        while (L[j] > key) and (j >= 0):
           L[j+1] = L[j]
           j -= 1
        L[j+1] = key
