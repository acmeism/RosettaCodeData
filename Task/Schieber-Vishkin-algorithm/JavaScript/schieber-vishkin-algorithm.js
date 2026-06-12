class Node {
  constructor() {
    this.child = 0;
    this.sib = 0;
    this.parent = 0;
  }
}

class Result {
  constructor(pi, beta, alfa, tau, lam) {
    this.pi = pi;
    this.beta = beta;
    this.alfa = alfa;
    this.tau = tau;
    this.lam = lam;
  }
}

function process(N, A) {
  const pi = Array(N + 1).fill(0);
  const beta = Array(N + 1).fill(0);
  const alfa = Array(N + 1).fill(0);
  const tau = Array(N + 1).fill(0);
  const lam = Array(N + 1).fill(0);
  const nodes = Array.from({ length: N + 1 }, () => new Node());

  let t = 0;

  // Build triply linked tree
  for (let v = N; v > 0; v--) {
    let u = 0;
    while (A[v] > A[t] || (A[v] === A[t] && v > t)) {
      u = t;
      t = nodes[t].parent;
    }

    if (u !== 0) {
      nodes[v].sib = nodes[u].sib;
      nodes[u].sib = 0;
      nodes[u].parent = v;
      nodes[v].child = u;
    } else {
      nodes[v].sib = nodes[t].child;
    }

    nodes[t].child = v;
    nodes[v].parent = t;
    t = v;
  }

  // First traversal
  let p = nodes[0].child;
  let n = 0;
  lam[0] = -1;

  while (traversal(nodes, p, n, pi, beta, tau, lam)) {
    n = getN();
    p = getP();
  }

  // Second traversal
  p = nodes[0].child;
  lam[0] = lam[n];
  pi[0] = beta[0] = alfa[0] = 0;

  if (p !== 0) {
    computeAlfa(nodes, p, alfa, beta);
  }

  return new Result(pi, beta, alfa, tau, lam);
}

// Static variables to simulate nonlocal variables
let p, n;

function getP() {
  return p;
}

function getN() {
  return n;
}

function traversal(nodes, initialP, initialN, pi, beta, tau, lam) {
  p = initialP;
  n = initialN;

  while (true) {
    n++;
    pi[p] = n;
    tau[n] = 0;
    lam[n] = 1 + lam[n >> 1];

    if (nodes[p].child !== 0) {
      p = nodes[p].child;
      continue;
    }

    beta[p] = n;
    break;
  }

  while (true) {
    tau[beta[p]] = nodes[p].parent;

    if (nodes[p].sib !== 0) {
      p = nodes[p].sib;
      return true;
    }

    p = nodes[p].parent;

    if (p !== 0) {
      const h = lam[n & -pi[p]];
      beta[p] = ((n >> h) | 1) << h;
    } else {
      return false;
    }
  }
}

function computeAlfa(nodes, node, alfa, beta) {
  alfa[node] = alfa[nodes[node].parent] | (beta[node] & -beta[node]);

  if (nodes[node].child !== 0) {
    computeAlfa(nodes, nodes[node].child, alfa, beta);
  }

  if (nodes[node].sib !== 0) {
    computeAlfa(nodes, nodes[node].sib, alfa, beta);
  }
}

function nca(x, y, beta, alfa, tau, lam, pi) {
  let h;
  if (beta[x] <= beta[y]) {
    h = lam[beta[y] & -beta[x]];
  } else {
    h = lam[beta[x] & -beta[y]];
  }

  const k = alfa[x] & alfa[y] & -(1 << h);
  h = lam[k & -k];

  const j = ((beta[x] >> h) | 1) << h;

  if (j !== beta[x]) {
    const l = lam[alfa[x] & ((1 << h) - 1)];
    x = tau[((beta[x] >> l) | 1) << l];
  }

  if (j !== beta[y]) {
    const l = lam[alfa[y] & ((1 << h) - 1)];
    y = tau[((beta[y] >> l) | 1) << l];
  }

  return pi[x] <= pi[y] ? x : y;
}

function solveTestCase(n, values, queries) {
  const results = [];
  const A = Array(n + 2).fill(0);
  const R = Array(n + 2).fill(0);
  const B = Array(n + 2).fill(0);

  A[0] = Number.MAX_SAFE_INTEGER;
  let N = 1;
  let count = 0;
  let oldx = null;

  for (let i = 1; i <= n; i++) {
    const x = values[i - 1];

    if (i > 1 && (oldx === null || x !== oldx)) {
      A[N] = count;
      R[N] = i;
      N++;
      count = 0;
    }

    B[i] = N;
    count++;
    oldx = x;
  }

  A[N] = count;
  R[N] = n + 1;

  const result = process(N, A);
  const { pi, beta, alfa, tau, lam } = result;

  for (const query of queries) {
    const [i, j] = query;
    const x = B[i];
    const y = B[j];

    let z;
    if (x === y) {
      z = j - i + 1;
    } else {
      if (x + 1 !== y) {
        z = A[nca(x + 1, y - 1, beta, alfa, tau, lam, pi)];
      } else {
        z = 0;
      }

      z = Math.max(z, Math.max(R[x] - i, A[y] - R[y] + j + 1));
    }

    results.push(z);
  }

  return results;
}

// Example usage
const testCases = [
  {
    n: 10,
    values: [-1, -1, 1, 1, 1, 1, 3, 10, 10, 10],
    queries: [
      [2, 3],
      [1, 10],
      [5, 10],
    ],
    expected: [1, 4, 3],
  },
];

for (const testCase of testCases) {
  const { n, values, queries, expected } = testCase;
  const results = solveTestCase(n, values, queries);
  console.log("Results:", results);
  console.log("Expected:", expected);
}
