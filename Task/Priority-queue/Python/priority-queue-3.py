>>> from heapq import heappush, heappop, heapify
>>> items = [(3, "Clear drains"), (4, "Feed cat"), (5, "Make tea"), (1, "Solve RC tasks"), (2, "Tax return")]
>>> heapify(items)
>>> while items:
  print(heappop(items))


(1, 'Solve RC tasks')
(2, 'Tax return')
(3, 'Clear drains')
(4, 'Feed cat')
(5, 'Make tea')
>>>
