import heapq
import sys

sources = sys.argv[1:]
for item in heapq.merge(open(source) for source in sources):
    print(item)
