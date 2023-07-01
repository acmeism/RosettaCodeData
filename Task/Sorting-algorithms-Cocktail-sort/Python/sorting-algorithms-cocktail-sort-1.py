def cocktailSort(A):
    up = range(len(A)-1)
    while True:
        for indices in (up, reversed(up)):
            swapped = False
            for i in indices:
                if A[i] > A[i+1]:
                    A[i], A[i+1] =  A[i+1], A[i]
                    swapped = True
            if not swapped:
                return
