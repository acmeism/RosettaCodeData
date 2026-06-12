from dataclasses import dataclass
from typing import Callable, List, Optional, Tuple
import math
import random
from functools import cmp_to_key

@dataclass
class Point:
    coords: Tuple[float, float]
    id_: int

@dataclass
class Edge:
    u: int
    v: int
    weight: float

    def __repr__(self) -> str:
        return f"({self.u},{self.v},{self.weight:.2f})"

class Graph:
    """
    Graph supporting Christofides algorithm for metric TSP approximation.
    """

    class UnionFind:
        def __init__(self, n: int):
            self.parent: List[int] = list(range(n))
            self.rank: List[int] = [0] * n

        def find(self, x: int) -> int:
            # Path compression
            if self.parent[x] != x:
                self.parent[x] = self.find(self.parent[x])
            return self.parent[x]

        def union(self, x: int, y: int) -> bool:
            # Union by rank
            rx, ry = self.find(x), self.find(y)
            if rx == ry:
                return False  # Already connected
            if self.rank[rx] < self.rank[ry]:
                self.parent[rx] = ry
            elif self.rank[rx] > self.rank[ry]:
                self.parent[ry] = rx
            else:
                self.parent[ry] = rx
                self.rank[rx] += 1
            return True

    def __init__(self, points: List[Point]):
        self.n = len(points)
        # Initialise distance matrix with distinct rows
        self.dist: List[List[float]] = [[0.0]*self.n for _ in range(self.n)]
        # Compute all pairwise Euclidean distances
        for i in range(self.n):
            for j in range(i+1, self.n):
                d = math.hypot(
                    points[i].coords[0]-points[j].coords[0],
                    points[i].coords[1]-points[j].coords[1]
                )
                self.dist[i][j] = self.dist[j][i] = d

    def minimumSpanningTree(self) -> List[Edge]:
        # Generate all edges between points
        edges = [
            Edge(i, j, self.dist[i][j])
            for i in range(self.n)
            for j in range(i+1, self.n)
        ]
        # Sort edges by weight (greedy approach)
        edges.sort(key=lambda e: e.weight)
        uf = Graph.UnionFind(self.n)
        mst: List[Edge] = []
        for e in edges:
            if uf.union(e.u, e.v):  # Only add edge if it doesn't form a cycle
                mst.append(e)
                if len(mst) == self.n - 1:
                    break  # MST completed
        return mst

    def oddVertices(self, mst: List[Edge]) -> List[int]:
        # Count degrees of each vertex in MST
        degree = [0] * self.n
        for e in mst:
            degree[e.u] += 1
            degree[e.v] += 1
        # Return vertices with odd degree
        return [i for i, deg in enumerate(degree) if deg % 2 == 1]

    def minimumWeightMatching(self, odd: List[int]) -> List[Edge]:
        # Greedy minimum weight matching on odd-degree vertices
        unmatched = set(odd)
        matching: List[Edge] = []
        while unmatched:
            v = unmatched.pop()
            # Find closest unmatched vertex
            u = min(unmatched, key=lambda x: self.dist[v][x])
            unmatched.remove(u)
            matching.append(Edge(v, u, self.dist[v][u]))
        return matching

    def eulerianTour(self, edges: List[Edge]) -> List[int]:
        # Construct adjacency list for multigraph
        adj: List[List[Tuple[int, int]]] = [[] for _ in range(self.n)]  # (neighbor, edge_id)
        for idx, e in enumerate(edges):
            adj[e.u].append((e.v, idx))
            adj[e.v].append((e.u, idx))
        used = [False]*len(edges)  # Track used edges
        stack = [0]  # Start DFS from vertex 0
        path: List[int] = []
        while stack:
            v = stack[-1]
            # Remove used edges
            while adj[v] and used[adj[v][-1][1]]:
                adj[v].pop()
            if not adj[v]:
                path.append(stack.pop())  # Backtrack
            else:
                u, eid = adj[v].pop()
                used[eid] = True
                stack.append(u)
        return path[::-1]  # Reverse to get correct order

    def makeHamiltonian(self, tour: List[int]) -> Tuple[List[int], float]:
        visited = set()
        circuit: List[int] = []
        length = 0.0
        for v in tour:
            if v not in visited:
                if circuit:
                    length += self.dist[circuit[-1]][v]  # Accumulate path length
                circuit.append(v)
                visited.add(v)
        # Close the circuit
        length += self.dist[circuit[-1]][circuit[0]]
        circuit.append(circuit[0])
        return circuit, length

# Christofides algorithm wrapper

def christofides(points: List[Point]) -> Tuple[List[int], float]:
    if not points:
        return [], 0.0
    g = Graph(points)
    mst = g.minimumSpanningTree()
    odd = g.oddVertices(mst)
    matching = g.minimumWeightMatching(odd)
    # Combine MST and matching to form multigraph
    multiedges = mst + matching
    tour = g.eulerianTour(multiedges)
    return g.makeHamiltonian(tour)

if __name__ == "__main__":
    # Sample test data (TSP instance)
    raw_data: list[tuple[int, int]] = [
        (1380, 939), (2848, 96), (3510, 1671), (457, 334), (3888, 666),
        (984, 965), (2721, 1482), (1286, 525), (2716, 1432), (738, 1325),
        (1251, 1832), (2728, 1698), (3815, 169), (3683, 1533), (1247,1945),
        (123, 862), (1234, 1946), (252, 1240), (611, 673), (2576, 1676),
        (928, 1700), (53, 857), (1807, 1711), (274, 1420), (2574, 946),
        (178, 24), (2678, 1825), (1795, 962), (3384, 1498), (3520, 1079),
        (1256, 61), (1424, 1728), (3913, 192), (3085, 1528), (2573, 1969),
        (463, 1670), (3875, 598), (298, 1513), (3479, 821), (2542, 236),
        (3955, 1743), (1323, 280), (3447, 1830), (2936, 337), (1621, 1830),
        (3373, 1646), (1393, 1368), (3874, 1318), (938, 955), (3022, 474),
        (2482, 1183), (3854, 923), (376, 825), (2519, 135), (2945, 1622),
        (953, 268), (2628, 1479), (2097, 981), (890, 1846), (2139, 1806),
        (2421, 1007), (2290, 1810), (1115, 1052), (2588, 302), (327, 265),
        (241, 341), (1917, 687), (2991, 792), (2573, 599), (19, 674),
        (3911, 1673), (872, 1559), (2863, 558), (929, 1766), (839, 620),
        (3893, 102), (2178, 1619), (3822, 899), (378, 1048), (1178, 100),
        (2599, 901), (3416, 143), (2961, 1605), (611, 1384), (3113, 885),
        (2597, 1830), (2586, 1286), (161, 906), (1429, 134), (742, 1025),
        (1625, 1651), (1187, 706), (1787, 1009), (22, 987), (3640, 43),
        (3756, 882), (776, 392), (1724, 1642), (198, 1810), (3950, 1558)
    ]
    # Create "Point" objects with IDs
    points = [Point(coords, i) for i, coords in enumerate(raw_data)]
    # Run Christofides algorithm
    tour, length = christofides(points)
    print("Tour:", tour)
    print("Length:", length)
