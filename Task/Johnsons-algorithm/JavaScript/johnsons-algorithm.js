// Johnson's Algorithm Implementation in JavaScript
// This algorithm finds all-pairs shortest paths in a weighted directed graph

// Constants
const INF = Number.MAX_VALUE;

// Edge class representing a directed edge from vertex u to vertex v with a weight
class Edge {
  constructor(u, v, weight) {
    this.u = u;
    this.v = v;
    this.weight = weight;
  }
}

// VertexAndWeight class for use in Dijkstra's algorithm
class VertexAndWeight {
  constructor(v, weight) {
    this.v = v;
    this.weight = weight;
  }
}

// WeightAndVertex class for use in the priority queue in Dijkstra's algorithm
class WeightAndVertex {
  constructor(weight, vertex) {
    this.weight = weight;
    this.vertex = vertex;
  }
}

// PriorityQueue implementation for Dijkstra's algorithm
class PriorityQueue {
  constructor() {
    this.items = [];
  }

  enqueue(weightAndVertex) {
    let added = false;
    for (let i = 0; i < this.items.length; i++) {
      if (weightAndVertex.weight < this.items[i].weight) {
        this.items.splice(i, 0, weightAndVertex);
        added = true;
        break;
      }
    }
    if (!added) {
      this.items.push(weightAndVertex);
    }
  }

  dequeue() {
    if (this.isEmpty()) return null;
    return this.items.shift();
  }

  isEmpty() {
    return this.items.length === 0;
  }
}

/**
 * Bellman-Ford algorithm to find shortest paths from a source vertex to all other vertices
 * Returns null if there is a negative cycle
 */
function bellmanFordAlgorithm(augmentedVertexCount, edges, sourceVertex) {
  // Initialize distances array with INF, except for the source vertex
  const distances = Array(augmentedVertexCount).fill(INF);
  distances[sourceVertex] = 0.0;

  // Relax the edges (augmentedVertexCount - 1) times
  let updated = true;
  for (let i = 0; i < augmentedVertexCount - 1 && updated; i++) {
    updated = false;
    for (let j = 0; j < edges.length; j++) {
      const edge = edges[j];
      if (distances[edge.u] !== INF && distances[edge.u] + edge.weight < distances[edge.v]) {
        distances[edge.v] = distances[edge.u] + edge.weight;
        updated = true;
      }
    }
  }

  // Check for negative cycles in the graph
  for (const edge of edges) {
    if (distances[edge.u] !== INF && distances[edge.u] + edge.weight < distances[edge.v]) {
      return null; // Indicates a negative cycle has been detected
    }
  }

  return distances;
}

/**
 * Dijkstra's algorithm to find shortest paths from a source vertex to all other vertices
 * in a graph with non-negative edge weights
 */
function dijkstraAlgorithm(vertexCount, reweightedAdjacencies, sourceVertex, values) {
  // Initialize distances array with INF
  const distances = Array(vertexCount).fill(INF);
  distances[sourceVertex] = 0.0;

  const priorityQueue = new PriorityQueue();
  priorityQueue.enqueue(new WeightAndVertex(0.0, sourceVertex));

  const finalDistances = Array(vertexCount).fill(INF);

  while (!priorityQueue.isEmpty()) {
    const weightAndVertex = priorityQueue.dequeue();
    const vertex = weightAndVertex.vertex;

    if (weightAndVertex.weight > distances[vertex]) {
      continue;
    }

    // Store the final shortest path distance, translated back to the distance in the original graph
    if (finalDistances[vertex] === INF) {
      if (distances[vertex] === INF) { // This should not happen, but is included as a safety check
        finalDistances[vertex] = INF;
      } else {
        // Translate distance back to its original weight: d(u,v) = d'(u,v) - h[u] + h[v]
        finalDistances[vertex] = distances[vertex] - values[sourceVertex] + values[vertex];
      }
    }

    // Relax the edges outgoing from vertex
    if (reweightedAdjacencies.has(vertex)) {
      for (const pair of reweightedAdjacencies.get(vertex)) {
        if (distances[vertex] !== INF && distances[vertex] + pair.weight < distances[pair.v]) {
          distances[pair.v] = distances[vertex] + pair.weight;
          priorityQueue.enqueue(new WeightAndVertex(distances[pair.v], pair.v));
        }
      }
    }
  }

  // Translate distance back to its original weight for any remaining reachable vertices
  for (let i = 0; i < vertexCount; i++) {
    if (finalDistances[i] === INF && distances[i] !== INF) {
      finalDistances[i] = distances[i] - values[sourceVertex] + values[i];
    }
  }

  return finalDistances;
}

/**
 * Johnson's algorithm to find shortest paths between all pairs of vertices
 * in a weighted directed graph which may contain negative edge weights
 */
function johnsonsAlgorithm(graph) {
  const vertexCount = graph.length;
  const originalEdges = [];

  // Step 0: Build a list of edges for the original graph
  for (let i = 0; i < vertexCount; i++) {
    for (let j = 0; j < vertexCount; j++) {
      const weight = graph[i][j];
      if (i === j) {
        if (weight !== 0.0) {
          console.log(`Warning: graph[i][i] for i = ${i} is ${weight}, expected to be 0.0, resetting it to 0.0`);
        }
      } else if (weight !== INF) {
        originalEdges.push(new Edge(i, j, weight));
      }
    }
  }

  // Step 1: Form the augmented graph
  // Add a new vertex with index 'vertexCount' and having 0-weight edges to all the original vertices
  const augmentedEdges = [...originalEdges];
  for (let i = 0; i < vertexCount; i++) {
    augmentedEdges.push(new Edge(vertexCount, i, 0.0));
  }

  // Step 2: Invoke the Bellman-Ford Algorithm starting from the new vertex
  const hValues = bellmanFordAlgorithm(vertexCount + 1, augmentedEdges, vertexCount);

  if (hValues === null) {
    return null; // A negative cycle was detected by the Bellman-Ford Algorithm
  }

  // Remove the value for the augmented vertex
  hValues.pop();

  // Step 3: Reweight the edges
  const reweightedAdjacencies = new Map();
  for (let i = 0; i < vertexCount; i++) {
    reweightedAdjacencies.set(i, []);
  }

  for (const edge of originalEdges) {
    // Ensure the 'hValues' are valid before reweighting
    if (hValues[edge.u] === INF || hValues[edge.v] === INF) {
      // This can happen if the original graph was not strongly connected to the augmented vertex.
      // While not strictly an error for Johnson's Algorithm, because paths might still exist between
      // reachable nodes, it means the reweighting might involve INF.
      // Computation can proceed since Dijkstra's Algorithm can handle INF.
      console.log("Warning: invalid hValues detected by the Bellman-Ford Algorithm.");
    }

    const reweight = edge.weight + hValues[edge.u] - hValues[edge.v];
    reweightedAdjacencies.get(edge.u).push(new VertexAndWeight(edge.v, reweight));
  }

  // Step 4: Invoke Dijkstra's Algorithm starting from each vertex on the reweighted graph
  const allPairsShortestPaths = [];
  for (let u = 0; u < vertexCount; u++) {
    allPairsShortestPaths.push(dijkstraAlgorithm(vertexCount, reweightedAdjacencies, u, hValues));
  }

  // Step 5: Return the result matrix
  return allPairsShortestPaths;
}

// Example usage
function main() {
  // The element (i, j) is the weight of the edge from vertex i to vertex j.
  // INF, for infinity, means that there is no edge from vertex i to vertex j.
  const graph = [
    [0.0, -5.0, 2.0, 3.0],
    [INF, 0.0, 4.0, INF],
    [INF, INF, 0.0, 1.0],
    [INF, INF, INF, 0.0]
  ];

  const result = johnsonsAlgorithm(graph);

  if (result) {
    console.log("All pairs shortest paths:");
    console.log("The element (i, j) is the shortest path between vertex i and vertex j.");
    for (const row of result) {
      let rowStr = "[";
      for (const number of row) {
        rowStr += (number === INF) ? "INF " : number + " ";
      }
      rowStr += "]";
      console.log(rowStr);
    }
  } else {
    console.log("A negative cycle was detected in the graph.");
  }
}

// Run the example
main();
