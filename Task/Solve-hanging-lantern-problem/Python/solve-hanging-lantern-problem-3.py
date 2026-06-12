def seq(x):
    if not any(x):
        yield tuple()

    for i, v in enumerate(x):
        if v:
            for s in seq(x[:i] + [v - 1] + x[i+1:]):
                yield (i+1,) + s

# an example
for x in seq([1, 2, 3]):
    print(x)
