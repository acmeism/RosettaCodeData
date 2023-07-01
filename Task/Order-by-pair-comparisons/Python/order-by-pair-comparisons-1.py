def _insort_right(a, x, q):
    """
    Insert item x in list a, and keep it sorted assuming a is sorted.
    If x is already in a, insert it to the right of the rightmost x.
    """

    lo, hi = 0, len(a)
    while lo < hi:
        mid = (lo+hi)//2
        q += 1
        less = input(f"{q:2}: IS {x:>6} LESS-THAN {a[mid]:>6} ? y/n: ").strip().lower() == 'y'
        if less: hi = mid
        else: lo = mid+1
    a.insert(lo, x)
    return q

def order(items):
    ordered, q = [], 0
    for item in items:
        q = _insort_right(ordered, item, q)
    return ordered, q

if __name__ == '__main__':
    items = 'violet red green indigo blue yellow orange'.split()
    ans, questions = order(items)
    print('\n' + ' '.join(ans))
