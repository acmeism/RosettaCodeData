from collections import namedtuple
from functools import total_ordering
from bisect import bisect_left

@total_ordering
class Node(namedtuple('Node_', 'val back')):
    def __iter__(self):
        while self is not None:
            yield self.val
            self = self.back
    def __lt__(self, other):
        return self.val < other.val
    def __eq__(self, other):
        return self.val == other.val

def lis(d):
    """Return one of the L.I.S. of list d using patience sorting."""
    if not d:
        return []
    pileTops = []
    for di in d:
        j = bisect_left(pileTops, Node(di, None))
        new_node = Node(di, pileTops[j-1] if j > 0 else None)
        if j == len(pileTops):
            pileTops.append(new_node)
        else:
            pileTops[j] = new_node

    return list(pileTops[-1])[::-1]

if __name__ == '__main__':
    for d in [[3,2,6,4,5,1],
              [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]]:
        print('a L.I.S. of %s is %s' % (d, lis(d)))
