def quickSort(a):
    if len(a) <= 1:
        return a
    else:
        less = []
        more = []
        pivot = choice(a)
        for i in a:
            if i < pivot:
                less.append(i)
            if i > pivot:
                more.append(i)
        less = quickSort(less)
        more = quickSort(more)
        return less + [pivot] * a.count(pivot) + more
