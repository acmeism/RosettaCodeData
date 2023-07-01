from collections import deque

some_list = deque(["a", "b", "c"])
print(some_list)

some_list.appendleft("Z")
print(some_list)

for value in reversed(some_list):
    print(value)
