def perim_equal(p1, p2):
    # Cheap tests first
    if len(p1) != len(p2) or set(p1) != set(p2):
        return False
    if any(p2 == (p1[n:] + p1[:n]) for n in range(len(p1))):
        return True
    p2 = p2[::-1] # not inplace
    return any(p2 == (p1[n:] + p1[:n]) for n in range(len(p1)))

def edge_to_periphery(e):
    edges = sorted(e)
    p = list(edges.pop(0)) if edges else []
    last = p[-1] if p else None
    while edges:
        for n, (i, j) in enumerate(edges):
            if i == last:
                p.append(j)
                last = j
                edges.pop(n)
                break
            elif j == last:
                p.append(i)
                last = i
                edges.pop(n)
                break
        else:
            #raise ValueError(f'Invalid edge format: {e}')
            return ">>>Error! Invalid edge format<<<"
    return p[:-1]

if __name__ == '__main__':
    print('Perimeter format equality checks:')
    for eq_check in [
            { 'Q': (8, 1, 3),
              'R': (1, 3, 8)},
            { 'U': (18, 8, 14, 10, 12, 17, 19),
              'V': (8, 14, 10, 12, 17, 19, 18)} ]:
        (n1, p1), (n2, p2) = eq_check.items()
        eq = '==' if perim_equal(p1, p2) else '!='
        print(' ', n1, eq, n2)

    print('\nEdge to perimeter format translations:')
    edge_d = {
     'E': {(1, 11), (7, 11), (1, 7)},
     'F': {(11, 23), (1, 17), (17, 23), (1, 11)},
     'G': {(8, 14), (17, 19), (10, 12), (10, 14), (12, 17), (8, 18), (18, 19)},
     'H': {(1, 3), (9, 11), (3, 11), (1, 11)}
            }
    for name, edges in edge_d.items():
        print(f"  {name}: {edges}\n     -> {edge_to_periphery(edges)}")
