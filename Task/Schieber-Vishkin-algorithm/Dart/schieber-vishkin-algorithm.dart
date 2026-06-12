import 'dart:math';
import 'dart:collection';

class Node {
  int child = 0;
  int sib = 0;
  int parent = 0;
}

class Result {
  List<int> pi;
  List<int> beta;
  List<int> alfa;
  List<int> tau;
  List<int> lam;

  Result(this.pi, this.beta, this.alfa, this.tau, this.lam);
}

class TestCase {
  int n;
  List<int> values;
  List<List<int>> queries;
  List<int> expected;

  TestCase(this.n, this.values, this.queries, this.expected);
}

// Static variables for traversal
int _p = 0;
int _n = 0;

int getP() => _p;
int getN() => _n;

bool traversal(List<Node> nodes, int initialP, int initialN, List<int> pi,
               List<int> beta, List<int> tau, List<int> lam) {
  _p = initialP;
  _n = initialN;

  // s3: Compute beta in the easy case
  while (true) {
    _n++;
    pi[_p] = _n;
    tau[_n] = 0;
    lam[_n] = 1 + lam[_n >> 1];

    if (nodes[_p].child != 0) {
      _p = nodes[_p].child;
      continue;
    }

    beta[_p] = _n;
    break;
  }

  // s4: Compute tau, bottom-up
  while (true) {
    tau[beta[_p]] = nodes[_p].parent;

    if (nodes[_p].sib != 0) {
      _p = nodes[_p].sib;
      return true;  // Go back to s3
    }

    _p = nodes[_p].parent;

    // Compute beta in the hard case
    if (_p != 0) {
      int h = lam[_n & -pi[_p]];
      beta[_p] = ((_n >> h) | 1) << h;
    } else {
      return false;  // Exit traversal
    }
  }
}

void compute_alfa(List<Node> nodes, int node, List<int> alfa, List<int> beta) {
  // s7: Compute alfa, top-down
  alfa[node] = alfa[nodes[node].parent] | (beta[node] & -beta[node]);

  if (nodes[node].child != 0) {
    compute_alfa(nodes, nodes[node].child, alfa, beta);
  }

  // s8: Continue traversal
  if (nodes[node].sib != 0) {
    compute_alfa(nodes, nodes[node].sib, alfa, beta);
  }
}

int nca(int x, int y, List<int> beta, List<int> alfa,
        List<int> tau, List<int> lam, List<int> pi) {
  // Find common height
  int h;
  if (beta[x] <= beta[y]) {
    h = lam[beta[y] & -beta[x]];
  } else {
    h = lam[beta[x] & -beta[y]];
  }

  // Find true height
  int k = alfa[x] & alfa[y] & -(1 << h);
  h = lam[k & -k];

  // Find beta[z]
  int j = ((beta[x] >> h) | 1) << h;

  // Find x' and y'
  if (j != beta[x]) {
    int l = lam[alfa[x] & ((1 << h) - 1)];
    x = tau[((beta[x] >> l) | 1) << l];
  }

  if (j != beta[y]) {
    int l = lam[alfa[y] & ((1 << h) - 1)];
    y = tau[((beta[y] >> l) | 1) << l];
  }

  // Find z
  int z = (pi[x] <= pi[y]) ? x : y;
  return z;
}

Result process(int N, List<int> A) {
  List<int> pi = List<int>.filled(N + 1, 0);
  List<int> beta = List<int>.filled(N + 1, 0);
  List<int> alfa = List<int>.filled(N + 1, 0);
  List<int> tau = List<int>.filled(N + 1, 0);
  List<int> lam = List<int>.filled(N + 1, 0);
  List<Node> nodes = List<Node>.generate(N + 1, (_) => Node());

  // Make triply linked tree
  int t = 0;
  for (int v = N; v > 0; v--) {
    int u = 0;
    while (A[v] > A[t] || (A[v] == A[t] && v > t)) {
      u = t;
      t = nodes[t].parent;
    }

    if (u != 0) {
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

  // Begin first traversal
  int p = nodes[0].child;
  int n = 0;
  lam[0] = -1;

  while (traversal(nodes, p, n, pi, beta, tau, lam)) {
    // Continue traversal
    n = getN();
    p = getP();
  }

  // Begin second traversal
  p = nodes[0].child;
  lam[0] = lam[n];
  pi[0] = beta[0] = alfa[0] = 0;

  // Perform second traversal
  if (p != 0) {
    compute_alfa(nodes, p, alfa, beta);
  }

  return Result(pi, beta, alfa, tau, lam);
}

List<int> solve_test_case(int n, List<int> values, List<List<int>> queries) {
  List<int> results = [];

  List<int> A = List<int>.filled(n + 2, 0);
  A[0] = 1 << 30;  // A[0] = MAX_INT
  List<int> R = List<int>.filled(n + 2, 0);
  List<int> B = List<int>.filled(n + 2, 0);

  int N = 1;
  int count = 0;
  int? oldx;

  for (int i = 1; i <= n; i++) {
    int x = values[i - 1];

    if (i > 1 && (oldx == null || x != oldx)) {
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

  Result result = process(N, A);
  List<int> pi = result.pi;
  List<int> beta = result.beta;
  List<int> alfa = result.alfa;
  List<int> tau = result.tau;
  List<int> lam = result.lam;

  for (List<int> query in queries) {
    int i = query[0];
    int j = query[1];
    int x = B[i];
    int y = B[j];

    int z;
    if (x == y) {
      z = j - i + 1;
    } else {
      if (x + 1 != y) {
        z = A[nca(x + 1, y - 1, beta, alfa, tau, lam, pi)];
      } else {
        z = 0;
      }

      z = max(z, max(R[x] - i, A[y] - R[y] + j + 1));
    }

    results.add(z);
  }

  return results;
}

void main() {
  // Hard-coded test data
  List<TestCase> testCases = [];
  testCases.add(TestCase(
    10,
    [-1, -1, 1, 1, 1, 1, 3, 10, 10, 10],
    [[2, 3], [1, 10], [5, 10]],
    [1, 4, 3]
  ));

  for (int idx = 0; idx < testCases.length; idx++) {
    TestCase test = testCases[idx];
    int n = test.n;
    List<int> values = test.values;
    List<List<int>> queries = test.queries;
    List<int> expected = test.expected;

    print("Test Case ${idx + 1}:");
    print("Size: $n, Queries: ${queries.length}");
    print("Values: ${values.join(' ')}");

    List<int> results = solve_test_case(n, values, queries);

    print("Queries and Results:");
    for (int q_idx = 0; q_idx < queries.length; q_idx++) {
      List<int> query = queries[q_idx];
      int result = results[q_idx];
      int exp = expected[q_idx];

      print("Query: ${query[0]} ${query[1]}");
      print("Result: $result (Expected: $exp)");
      if (result != exp) {
        print("  WARNING: Result doesn't match expected output");
      }
    }

    print("");
  }
}
