from collections import defaultdict

def from_edges(edges):
    '''translate list of edges to list of nodes'''

    class Node:
        def __init__(self):
            # root is one of:
            #   None: not yet visited
            #   -1: already processed
            #   non-negative integer: what Wikipedia pseudo code calls 'lowlink'
            self.root = None
            self.succ = []

    nodes = defaultdict(Node)
    for v,w in edges:
        nodes[v].succ.append(nodes[w])

    for i,v in nodes.items(): # name the nodes for final output
        v.id = i

    return nodes.values()

def trajan(V):
    def strongconnect(v, S):
        v.root = pos = len(S)
        S.append(v)

        for w in v.succ:
            if w.root is None:  # not yet visited
                yield from strongconnect(w, S)

            if w.root >= 0:  # still on stack
                v.root = min(v.root, w.root)

        if v.root == pos:  # v is the root, return everything above
            res, S[pos:] = S[pos:], []
            for w in res:
                w.root = -1
            yield [r.id for r in res]

    for v in V:
        if v.root is None:
            yield from strongconnect(v, [])


tables = [  # table 1
            [(1,2), (3,1), (3,6), (6,7), (7,6), (2,3), (4,2),
             (4,3), (4,5), (5,6), (5,4), (8,5), (8,7), (8,6)],

            # table 2
            [('A', 'B'), ('B', 'C'), ('C', 'A'), ('A', 'Other')]]

for table in (tables):
    for g in trajan(from_edges(table)):
        print(g)
    print()
