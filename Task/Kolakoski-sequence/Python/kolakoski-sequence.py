import itertools

def cycler(start_items):
	return itertools.cycle(start_items).__next__

def _kolakoski_gen(start_items):
    s, k = [], 0
    c = cycler(start_items)
    while True:
        c_next = c()
        s.append(c_next)
        sk = s[k]
        yield sk
        if sk > 1:
            s += [c_next] * (sk - 1)
        k += 1

def kolakoski(start_items=(1, 2), length=20):
    return list(itertools.islice(_kolakoski_gen(start_items), length))

def _run_len_encoding(truncated_series):
    return [len(list(group)) for grouper, group in itertools.groupby(truncated_series)][:-1]

def is_series_eq_its_rle(series):
    rle = _run_len_encoding(series)
    return (series[:len(rle)] == rle) if rle else not series

if __name__ == '__main__':
    for start_items, length in [((1, 2), 20), ((2, 1), 20),
                                ((1, 3, 1, 2), 30), ((1, 3, 2, 1), 30)]:
        print(f'\n## {length} members of the series generated from {start_items} is:')
        s = kolakoski(start_items, length)
        print(f'  {s}')
        ans = 'YES' if is_series_eq_its_rle(s) else 'NO'
        print(f'  Does it look like a Kolakoski sequence: {ans}')
