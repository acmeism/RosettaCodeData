def stern_brocot(predicate=lambda series: len(series) < 20):
    """\
    Generates members of the stern-brocot series, in order, returning them when the predicate becomes false

    >>> print('The first 10 values:',
              stern_brocot(lambda series: len(series) < 10)[:10])
    The first 10 values: [1, 1, 2, 1, 3, 2, 3, 1, 4, 3]
    >>>
    """

    sb, i = [1, 1], 0
    while predicate(sb):
        sb += [sum(sb[i:i + 2]), sb[i + 1]]
        i += 1
    return sb


if __name__ == '__main__':
    from fractions import gcd

    n_first = 15
    print('The first %i values:\n  ' % n_first,
          stern_brocot(lambda series: len(series) < n_first)[:n_first])
    print()
    n_max = 10
    for n_occur in list(range(1, n_max + 1)) + [100]:
        print('1-based index of the first occurrence of %3i in the series:' % n_occur,
              stern_brocot(lambda series: n_occur not in series).index(n_occur) + 1)
              # The following would be much faster. Note that new values always occur at odd indices
              # len(stern_brocot(lambda series: n_occur != series[-2])) - 1)

    print()
    n_gcd = 1000
    s = stern_brocot(lambda series: len(series) < n_gcd)[:n_gcd]
    assert all(gcd(prev, this) == 1
               for prev, this in zip(s, s[1:])), 'A fraction from adjacent terms is reducible'
