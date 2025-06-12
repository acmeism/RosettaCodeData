from more_itertools import groupby_transform, take, ilen

def lookandsay(seq = "1"):
    yield seq
    while True:
        yield (seq := "".join(f"{count}{n}" for n, count in
                            groupby_transform(seq, reducefunc = ilen)))

list(take(5, lookandsay()))
