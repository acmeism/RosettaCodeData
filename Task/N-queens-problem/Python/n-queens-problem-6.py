def queens(x, i, a, b, c):
    if a:  # a is not empty
        for j in a:
            if i + j not in b and i - j not in c:
                yield from queens(x + [j], i + 1, a - {j}, b | {i + j}, c | {i - j})
    else:
        yield x

for solution in queens([], 0, set(range(8)), set(), set()):
    print(solution)
