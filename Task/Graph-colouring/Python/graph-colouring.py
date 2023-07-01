import re
from collections import defaultdict
from itertools import count


connection_re = r"""
    (?: (?P<N1>\d+) - (?P<N2>\d+) | (?P<N>\d+) (?!\s*-))
    """

class Graph:

    def __init__(self, name, connections):
        self.name = name
        self.connections = connections
        g = self.graph = defaultdict(list)  # maps vertex to direct connections

        matches = re.finditer(connection_re, connections,
                              re.MULTILINE | re.VERBOSE)
        for match in matches:
            n1, n2, n = match.groups()
            if n:
                g[n] += []
            else:
                g[n1].append(n2)    # Each the neighbour of the other
                g[n2].append(n1)

    def greedy_colour(self, order=None):
        "Greedy colourisation algo."
        if order is None:
            order = self.graph      # Choose something
        colour = self.colour = {}
        neighbours = self.graph
        for node in order:
            used_neighbour_colours = (colour[nbr] for nbr in neighbours[node]
                                      if nbr in colour)
            colour[node] = first_avail_int(used_neighbour_colours)
        self.pp_colours()
        return colour

    def pp_colours(self):
        print(f"\n{self.name}")
        c = self.colour
        e = canonical_edges = set()
        for n1, neighbours in sorted(self.graph.items()):
            if neighbours:
                for n2 in neighbours:
                    edge = tuple(sorted([n1, n2]))
                    if edge not in canonical_edges:
                        print(f"       {n1}-{n2}: Colour: {c[n1]}, {c[n2]}")
                        canonical_edges.add(edge)
            else:
                print(f"         {n1}: Colour: {c[n1]}")
        lc = len(set(c.values()))
        print(f"    #Nodes: {len(c)}\n    #Edges: {len(e)}\n  #Colours: {lc}")


def first_avail_int(data):
    "return lowest int 0... not in data"
    d = set(data)
    for i in count():
        if i not in d:
            return i


if __name__ == '__main__':
    for name, connections in [
            ('Ex1', "0-1 1-2 2-0 3"),
            ('Ex2', "1-6 1-7 1-8 2-5 2-7 2-8 3-5 3-6 3-8 4-5 4-6 4-7"),
            ('Ex3', "1-4 1-6 1-8 3-2 3-6 3-8 5-2 5-4 5-8 7-2 7-4 7-6"),
            ('Ex4', "1-6 7-1 8-1 5-2 2-7 2-8 3-5 6-3 3-8 4-5 4-6 4-7"),
            ]:
        g = Graph(name, connections)
        g.greedy_colour()
