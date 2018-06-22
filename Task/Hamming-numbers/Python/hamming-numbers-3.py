from heapq import heappush, heappop
from itertools import islice

def h():
    heap = [1]
    while True:
        h = heappop(heap)
        while heap and h==heap[0]:
            heappop(heap)
        for m in [2,3,5]:
            heappush(heap, m*h)
        yield h

print list(islice(h(), 20))
print list(islice(h(), 1690, 1691))
print list(islice(h(), 999999, 1000000)) # runtime 9.5 sec on i5-3570S
