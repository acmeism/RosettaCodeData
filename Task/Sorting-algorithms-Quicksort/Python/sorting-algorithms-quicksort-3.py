def qsort(list):
    if not list:
        return []
    else:
        pivot = list[0]
        less = [x for x in list[1:]   if x <  pivot]
        more = [x for x in list[1:] if x >= pivot]
        return qsort(less) + [pivot] + qsort(more)
