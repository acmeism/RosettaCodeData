def qsort(array):
    if len(array) < 2:
        return array
    head, *tail = array
    less = qsort([i for i in tail if i < head])
    more = qsort([i for i in tail if i >= head])
    return less + [head] + more
