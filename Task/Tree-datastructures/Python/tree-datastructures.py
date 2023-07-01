from pprint import pprint as pp

def to_indent(node, depth=0, flat=None):
    if flat is None:
        flat = []
    if node:
        flat.append((depth, node[0]))
    for child in node[1]:
        to_indent(child, depth + 1, flat)
    return flat

def to_nest(lst, depth=0, level=None):
    if level is None:
        level = []
    while lst:
        d, name = lst[0]
        if d == depth:
            children = []
            level.append((name, children))
            lst.pop(0)
        elif d > depth:  # down
            to_nest(lst, d, children)
        elif d < depth:  # up
            return
    return level[0] if level else None

if __name__ == '__main__':
    print('Start Nest format:')
    nest = ('RosettaCode', [('rocks', [('code', []), ('comparison', []), ('wiki', [])]),
                            ('mocks', [('trolling', [])])])
    pp(nest, width=25)

    print('\n... To Indent format:')
    as_ind = to_indent(nest)
    pp(as_ind, width=25)

    print('\n... To Nest format:')
    as_nest = to_nest(as_ind)
    pp(as_nest, width=25)

    if nest != as_nest:
        print("Whoops round-trip issues")
