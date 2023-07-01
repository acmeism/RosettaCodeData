from elementary_cellular_automaton import eca, eca_wrap

def rule30bytes(lencells=100):
    cells = '1' + '0' * (lencells - 1)
    gen = eca(cells, 30)
    while True:
        yield int(''.join(next(gen)[0] for i in range(8)), 2)

if __name__ == '__main__':
    print([b for i,b in zip(range(10), rule30bytes())])
