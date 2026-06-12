class Edge {
  constructor(u, v, weight) {
    this.u = u;
    this.v = v;
    this.weight = weight;
  }

  getU() {
    return this.u;
  }

  getV() {
    return this.v;
  }

  getWeight() {
    return this.weight;
  }
}

class Graph {
  constructor(vertexCount) {
    this.vertexCount = vertexCount;
    this.edges = [];
  }

  addEdge(edge) {
    this.edges.push(edge);
  }

  // Return the minimum spanning tree by using Boruvka's algorithm
  borůvkaMinimumSpanningTree() {
    const parent = Array.from({ length: this.vertexCount }, (_, i) => i);
    const rank = Array(this.vertexCount).fill(0);

    // Store the indexes of the cheapest edge of each tree
    const cheapest = Array.from({ length: this.vertexCount }, () => new Edge(-1, -1, -1.0));

    // Initially there are 'vertexCount' different trees
    let treeCount = this.vertexCount;
    let minimumSpanningTreeWeight = 0;

    // Combine trees until all trees are combined into a single minimum spanning tree
    while (treeCount > 1) {
      // Traverse through all edges and update cheapest edge for every tree
      for (const edge of this.edges) {
        const u = edge.getU();
        const v = edge.getV();
        const weight = edge.getWeight();

        const index1 = this.find(parent, u);
        const index2 = this.find(parent, v);

        // If the two vertices of the current edge belong to different trees,
        // check whether the current edge is cheaper than previous cheapest edges
        if (index1 !== index2) {
          if (cheapest[index1].getWeight() === -1.0 || cheapest[index1].getWeight() > weight) {
            cheapest[index1] = new Edge(u, v, weight);
          }
          if (cheapest[index2].getWeight() === -1.0 || cheapest[index2].getWeight() > weight) {
            cheapest[index2] = new Edge(u, v, weight);
          }
        }
      }

      // Add the cheapest edges to the minimum spanning tree
      for (let vertex = 0; vertex < this.vertexCount; vertex++) {
        // Check whether the cheapest edge for current vertex exists
        if (cheapest[vertex].getWeight() !== -1.0) {
          const u = cheapest[vertex].getU();
          const v = cheapest[vertex].getV();
          const weight = cheapest[vertex].getWeight();

          const index1 = this.find(parent, u);
          const index2 = this.find(parent, v);

          if (index1 !== index2) {
            minimumSpanningTreeWeight += weight;
            this.unionSet(parent, rank, index1, index2);
            console.log(`Edge ${u}--${v} with weight ${weight} is included in the minimum spanning tree`);
            treeCount -= 1;
          }
        }
      }
    }

    console.log(`\nWeight of minimum spanning tree is ${minimumSpanningTreeWeight}`);
  }

  // Return the index of the tree containing 'vertex', using a path compression technique
  find(parent, vertex) {
    if (parent[vertex] !== vertex) {
      parent[vertex] = this.find(parent, parent[vertex]);
    }

    return parent[vertex];
  }

  // Form the union by rank of the two trees indexed by u and v
  unionSet(parent, rank, u, v) {
    const uRoot = this.find(parent, u);
    const vRoot = this.find(parent, v);

    // Attach the smaller rank tree under root of the high rank tree
    if (rank[uRoot] < rank[vRoot]) {
      parent[uRoot] = vRoot;
    } else if (rank[uRoot] > rank[vRoot]) {
      parent[vRoot] = uRoot;
    } else {
      // If ranks are the same, make one the root and increment its rank
      parent[vRoot] = uRoot;
      rank[uRoot] += 1;
    }
  }
}

// Main function equivalent
function main() {
  const graph = new Graph(4);
  graph.addEdge(new Edge(0, 1, 10.0));
  graph.addEdge(new Edge(0, 2, 6.0));
  graph.addEdge(new Edge(0, 3, 5.0));
  graph.addEdge(new Edge(1, 3, 15.0));
  graph.addEdge(new Edge(2, 3, 4.0));

  graph.borůvkaMinimumSpanningTree();
}

// Run the algorithm
main();
