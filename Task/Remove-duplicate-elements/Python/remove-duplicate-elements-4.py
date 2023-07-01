items = [1, 2, 3, 'a', 'b', 'c', 2, 3, 4, 'b', 'c', 'd']
unique = []
for x in items:
    if x not in unique:
        unique.append(x)
