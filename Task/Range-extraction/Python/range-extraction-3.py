class PushableIter():
    "Can push items back on iterable"
    def __init__(self, it):
        self.it = iter(it)
        self.pushed = []

    def push(self, item):
        self.pushed.append(item)

    def pop(self):
        return self.pushed.pop(0) if self.pushed else self.it.__next__()

    def __iter__(self):
        return self

    def __next__(self):
        return self.pop()

def range_extractp(sorted_iterable):
    'Yield 2-tuple ranges or 1-tuple single elements from iter of increasing ints'
    rest = PushableIter(sorted_iterable)
    for this in rest:
        low = hi = last = this
        for nxt in rest:        # Find upper range on incremented values
            if nxt == last + 1:
                last = hi = nxt
            else:       # Out of (sub)-range
                rest.push(nxt)
                break
        if   hi - low >= 2:
            yield (low, hi)
        elif hi - low == 1:
            yield (low,)
            yield (hi,)
        else:
            yield (low,)
