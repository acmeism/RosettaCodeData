from collections import defaultdict


class Graph:
    "Directed Graph Tarjan's strongly connected components algorithm"

    def __init__(self, name, connections):
        self.name = name
        self.connections = connections
        g = defaultdict(list)  # map node vertex to direct connections
        for n1, n2 in connections:
            if n1 != n2:
                g[n1].append(n2)
            else:
                g[n1]
        for _, n2 in connections:
            g[n2]   # For leaf nodes having no edges from themselves
        self.graph = dict(g)
        self.tarjan_algo()

    def _visitor(self, this, low, disc, stack):
        '''
        Recursive function that finds SCC's
        using DFS traversal of vertices.

        Arguments:
            this        --> Vertex to be visited in this call.
            disc{}      --> Discovery order of visited vertices.
            low{}       --> Connected vertex of earliest discovery order
            stack       --> Ancestor node stack during DFS.
        '''

        disc[this] = low[this] = self._order
        self._order += 1
        stack.append(this)

        for neighbr in self.graph[this]:
            if neighbr not in disc:
                # neighbour not visited so do DFS recurrence.
                self._visitor(neighbr, low, disc, stack)
                low[this] = min(low[this], low[neighbr])  # Prior connection?

            elif neighbr in stack:
                # Update low value of this only if neighbr in stack
                low[this] = min(low[this], disc[neighbr])

        if low[this] == disc[this]:
            # Head node found of SCC
            top, new = None, []
            while top != this:
                top = stack.pop()
                new.append(top)
            self.scc.append(new)

    def tarjan_algo(self):
        '''
        Recursive function that finds strongly connected components
        using the Tarjan Algorithm and function _visitor() to visit nodes.
        '''

        self._order = 0         # Visitation order counter
        disc, low = {}, {}
        stack = []

        self.scc = []           # SCC result accumulator
        for vertex in sorted(self.graph):
            if vertex not in disc:
                self._visitor(vertex, low, disc, stack)
        self._disc, self._low = disc, low


if __name__ == '__main__':
    for n, m in [('Tx1', '10 02 21 03 34'.split()),
                 ('Tx2', '01 12 23'.split()),
                 ('Tx3', '01 12 20 13 14 16 35 45'.split()),
                 ('Tx4', '01 03 12 14 20 26 32 45 46 56 57 58 59 64 79 89 98 AA'.split()),
                 ('Tx5', '01 12 23 24 30 42'.split()),
                 ]:
        print(f"\n\nGraph({repr(n)}, {m}):\n")
        g = Graph(n, m)
        print("               : ", '  '.join(str(v) for v in sorted(g._disc)))
        print("    DISC of", g.name + ':', [v for _, v in sorted(g._disc.items())])
        print("     LOW of", g.name + ':', [v for _, v in sorted(g._low.items())])
        scc = repr(g.scc if g.scc else '').replace("'", '').replace(',', '')[1:-1]
        print("\n   SCC's of", g.name + ':', scc)
