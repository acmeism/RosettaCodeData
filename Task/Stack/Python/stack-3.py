class Stack:
    def __init__(self):
        self._first = None
    def __nonzero__(self):
        return self._first is not None
    def append(self, value):
        self._first = (value, self._first)
    def pop(self):
        if self._first is None:
            raise IndexError, "pop from empty stack"
        value, self._first = self._first
        return value
