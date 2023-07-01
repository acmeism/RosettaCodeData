l = [ 10, 20, 30, 40 ]
for i in l:
    print(i)
for i in reversed(l):    # reversed produces an iterator, so only O(1) memory is used
    print(i)
