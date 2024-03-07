'use strict'
let numVertices = 4;
let weights = [ [ 1, 3, -2 ], [ 2, 1, 4 ], [ 2, 3, 3 ], [ 3, 4, 2 ], [ 4, 2, -1 ] ];

let graph = [];
for (let i = 0; i < numVertices; ++i) {
  graph.push([]);
  for (let j = 0; j < numVertices; ++j)
    graph[i].push(i == j ? 0 : 9999999);
}

for (let i = 0; i < weights.length; ++i) {
  let w = weights[i];
  graph[w[0] - 1][w[1] - 1] = w[2];
}

let nxt = [];
for (let i = 0; i < numVertices; ++i) {
  nxt.push([]);
  for (let j = 0; j < numVertices; ++j)
    nxt[i].push(i == j ? 0 : j + 1);
}

for (let k = 0; k < numVertices; ++k) {
  for (let i = 0; i < numVertices; ++i) {
    for (let j = 0; j < numVertices; ++j) {
      if (graph[i][j] > graph[i][k] + graph[k][j]) {
        graph[i][j] = graph[i][k] + graph[k][j];
        nxt[i][j] = nxt[i][k];
      }
    }
  }
}

console.log("pair     dist    path");
for (let i = 0; i < numVertices; ++i) {
  for (let j = 0; j < numVertices; ++j) {
    if (i != j) {
      let u = i + 1;
      let v = j + 1;
      let path = u + " -> " + v + "    " + graph[i][j].toString().padStart(2) + "     " + u;
      do {
           u = nxt[u - 1][v - 1];
           path = path + " -> " + u;
      } while (u != v);
      console.log(path)
    }
  }
}
