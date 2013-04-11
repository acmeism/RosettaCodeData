from collections import deque

class Stack:
    def __init__(self):
        self._items = deque()
    def append(self, item):
        self._items.append(item)
    def pop(self):
        return self._items.pop()
    def __nonzero__(self):
        return bool(self._items)
