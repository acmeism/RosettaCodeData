def rule30bytes(lencells=100):
    cells = '1' + '0' * (lencells - 1)
    gen = eca_wrap(cells, 30)
    while True:
        yield int(''.join(next(gen)[0] for i in range(8)), 2))
