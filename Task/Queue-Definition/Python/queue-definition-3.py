from collections import deque
fifo = deque()
fifo. appendleft(value) # push
value = fifo.pop()
not fifo # empty
fifo.pop() # raises IndexError when empty
