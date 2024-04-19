def queens(i: int, a: set):
    if a:  # set a is not empty
        for j in a:
            if i + j not in b and i - j not in c:
                b.add(i + j); c.add(i - j); x.append(j)
                yield from queens(i + 1, a - {j})
                b.remove(i + j); c.remove(i - j); x.pop()
    else:
        yield x


b = set(); c = set(); x = []
for solution in queens(0, set(range(8))):
    print(solution)
