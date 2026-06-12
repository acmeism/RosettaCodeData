from typing import List
from dataclasses import dataclass

# Define the structure of an Edge with two endpoints (u, v) and a weight
@dataclass
class Edge:
    u: int
    v: int
    weight: float

# Graph class to represent an undirected weighted graph
class Graph:

    def __init__(self, vertices: int):
        # Number of vertices in the graph
        self.vertices: int = vertices
        # List to store all edges of the graph
        self.edges: List[Edge] = []

    # Add an edge to the graph
    def addEdge(self, edge: Edge):
        self.edges.append(edge)

    # Function to find the Minimum Spanning Tree using Borůvka's algorithm
    def boruvkaMinimumSpanningTree(self):
        # Initialise parent and rank arrays for Union-Find
        parent: List[int] = list(range(self.vertices))
        rank: List[int] = [0 for _ in range(self.vertices)]
        # Array to store the cheapest edge for each component
        cheapest: List[Edge] = [Edge(-1, -1, -1.0) for _ in range(self.vertices)]

        # Start with all vertices as separate trees (components)
        treeCount: int = self.vertices
        minimumSpanningTreeWeight: int = 0

        # Continue until all components are connected (i.e., MST has V-1 edges)
        while treeCount > 1:
            # Step 1: For each edge, find if it connects two different components
            for edge in self.edges:
                u: int = edge.u
                v: int = edge.v
                weight: float = edge.weight

                # Find components (roots) of both endpoints
                index1: int = self.find(parent, u)
                index2: int = self.find(parent, v)

                # If they are in different components
                if index1 != index2:
                    # Update the cheapest edge for both components if needed
                    if cheapest[index1].weight == -1.0 or cheapest[index1].weight > weight:
                        cheapest[index1] = Edge(u, v, weight)
                    if cheapest[index2].weight == -1.0 or cheapest[index2].weight > weight:
                        cheapest[index2] = Edge(u, v, weight)

            # Step 2: Add the selected cheapest edges to the MST
            for vertex in range(self.vertices):
                if cheapest[vertex].weight != -1.0:
                    u: int = cheapest[vertex].u
                    v: int = cheapest[vertex].v
                    weight: int = cheapest[vertex].weight

                    index1: int = self.find(parent, u)
                    index2: int = self.find(parent, v)

                    # If the endpoints are still in different components
                    if index1 != index2:
                        # Include this edge in MST
                        minimumSpanningTreeWeight += weight
                        self.unionSet(parent, rank, index1, index2)
                        print(f"Edge {u}--{v} with weight {weight} is included in the minimum spanning tree")
                        treeCount -= 1

            # Reset the cheapest array for the next iteration
            cheapest = [Edge(-1, -1, -1.0) for _ in range(self.vertices)]

        # Print the total weight of the MST
        print(f"Weight of minimum spanning tree is {minimumSpanningTreeWeight}")

    # Find function with path compression for Union-Find
    def find(self, parent: List[int], vertex: int) -> int:
        if parent[vertex] != vertex:
            parent[vertex] = self.find(parent, parent[vertex])
        return parent[vertex]

    # Union function with union by rank for Union-Find
    def unionSet(self, parent: List[int], rank: List[int], u: int, v: int):
        uRoot: int = self.find(parent, u)
        vRoot: int = self.find(parent, v)

        # Attach smaller tree under root of larger tree
        if rank[uRoot] < rank[vRoot]:
            parent[uRoot] = vRoot
        elif uRoot > vRoot:
            parent[vRoot] = uRoot
        else:
            parent[vRoot] = uRoot
            rank[uRoot] = rank[uRoot] + 1

if __name__ == "__main__":
    # Create a graph with 4 vertices
    graph: Graph = Graph(4)

    # Add 5 edges to the graph
    graph.addEdge(Edge(0, 1, 10.0))
    graph.addEdge(Edge(0, 2, 6.0))
    graph.addEdge(Edge(0, 3, 5.0))
    graph.addEdge(Edge(1, 3, 15.0))
    graph.addEdge(Edge(2, 3, 4.0))

    # Find and print the MST using Borůvka's algorithm
    graph.boruvkaMinimumSpanningTree()
