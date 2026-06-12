import scala.collection.mutable.ArrayBuffer
import scala.util.control.Breaks._


object Main {
  case class Node(var child: Int = 0, var sib: Int = 0, var parent: Int = 0)

  case class Result(pi: Array[Int], beta: Array[Int], alfa: Array[Int], tau: Array[Int], lam: Array[Int])

  case class TestCase(n: Int, values: Array[Int], queries: Array[Array[Int]], expected: Array[Int])

  case class TraversalState(var p: Int, var n: Int)

  def process(N: Int, A: Array[Int]): Result = {
    val pi = Array.ofDim[Int](N + 1)
    val beta = Array.ofDim[Int](N + 1)
    val alfa = Array.ofDim[Int](N + 1)
    val tau = Array.ofDim[Int](N + 1)
    val lam = Array.ofDim[Int](N + 1)
    val nodes = Array.fill(N + 1)(Node())

    // Make triply linked tree
    var t = 0
    for (v <- N to 1 by -1) {
      var u = 0
      while (A(v) > A(t) || (A(v) == A(t) && v > t)) {
        u = t
        t = nodes(t).parent
      }

      if (u != 0) {
        nodes(v).sib = nodes(u).sib
        nodes(u).sib = 0
        nodes(u).parent = v
        nodes(v).child = u
      } else {
        nodes(v).sib = nodes(t).child
      }

      nodes(t).child = v
      nodes(v).parent = t
      t = v
    }

    // Begin first traversal
    var p = nodes(0).child
    var n = 0
    lam(0) = -1

    // Using a mutable object to simulate pass-by-reference behavior

    val state = TraversalState(p, n)

    while (traversal(nodes, state, pi, beta, tau, lam)) {
      // Continue traversal
      n = state.n
      p = state.p
    }

    // Begin second traversal
    p = nodes(0).child
    lam(0) = lam(n)
    pi(0) = 0
    beta(0) = 0
    alfa(0) = 0

    // Perform second traversal
    if (p != 0) {
      compute_alfa(nodes, p, alfa, beta)
    }

    Result(pi, beta, alfa, tau, lam)
  }

  def traversal(nodes: Array[Node], state: TraversalState, pi: Array[Int], beta: Array[Int], tau: Array[Int], lam: Array[Int]): Boolean = {
    // s3: Compute beta in the easy case
    breakable({
    while (true) {
      state.n += 1
      pi(state.p) = state.n
      tau(state.n) = 0
      lam(state.n) = 1 + lam(state.n >> 1)

      breakable({
      if (nodes(state.p).child != 0) {
        state.p = nodes(state.p).child
        return true
      }
      });

      beta(state.p) = state.n
      break;  //break
    }
    });

    // s4: Compute tau, bottom-up
    while (true) {
      tau(beta(state.p)) = nodes(state.p).parent

      if (nodes(state.p).sib != 0) {
        state.p = nodes(state.p).sib
        return true  // Go back to s3
      }

      state.p = nodes(state.p).parent

      // Compute beta in the hard case
      if (state.p != 0) {
        val h = lam(state.n & -pi(state.p))
        beta(state.p) = ((state.n >> h) | 1) << h
      } else {
        return false  // Exit traversal
      }
    }

    false // Should never reach here due to returns above
  }

  def compute_alfa(nodes: Array[Node], node: Int, alfa: Array[Int], beta: Array[Int]): Unit = {
    // s7: Compute alfa, top-down
    alfa(node) = alfa(nodes(node).parent) | (beta(node) & -beta(node))

    if (nodes(node).child != 0) {
      compute_alfa(nodes, nodes(node).child, alfa, beta)
    }

    // s8: Continue traversal
    if (nodes(node).sib != 0) {
      compute_alfa(nodes, nodes(node).sib, alfa, beta)
    }
  }

  def nca(x: Int, y: Int, beta: Array[Int], alfa: Array[Int], tau: Array[Int], lam: Array[Int], pi: Array[Int]): Int = {
    // Find common height
    val h = if (beta(x) <= beta(y)) {
      lam(beta(y) & -beta(x))
    } else {
      lam(beta(x) & -beta(y))
    }

    // Find true height
    val k = alfa(x) & alfa(y) & -(1 << h)
    val trueHeight = lam(k & -k)

    // Find beta(z)
    val j = ((beta(x) >> trueHeight) | 1) << trueHeight

    // Find x' and y'
    var newX = x
    var newY = y

    if (j != beta(x)) {
      val l = lam(alfa(x) & ((1 << trueHeight) - 1))
      newX = tau(((beta(x) >> l) | 1) << l)
    }

    if (j != beta(y)) {
      val l = lam(alfa(y) & ((1 << trueHeight) - 1))
      newY = tau(((beta(y) >> l) | 1) << l)
    }

    // Find z
    if (pi(newX) <= pi(newY)) newX else newY
  }

  def solve_test_case(n: Int, values: Array[Int], queries: Array[Array[Int]]): ArrayBuffer[Int] = {
    val results = ArrayBuffer[Int]()

    val A = Array.ofDim[Int](n + 2)
    A(0) = Int.MaxValue  // A(0)
    val R = Array.ofDim[Int](n + 2)
    val B = Array.ofDim[Int](n + 2)

    var N = 1
    var count = 0
    var oldx: Option[Int] = None

    for (i <- 1 to n) {
      val x = values(i - 1)

      if (i > 1 && (oldx.isEmpty || x != oldx.get)) {
        A(N) = count
        R(N) = i
        N += 1
        count = 0
      }

      B(i) = N
      count += 1
      oldx = Some(x)
    }

    A(N) = count
    R(N) = n + 1

    val result = process(N, A)
    val pi = result.pi
    val beta = result.beta
    val alfa = result.alfa
    val tau = result.tau
    val lam = result.lam

    for (query <- queries) {
      val i = query(0)
      val j = query(1)
      val x = B(i)
      val y = B(j)

      val z = if (x == y) {
        j - i + 1
      } else {
        val commonLength = if (x + 1 != y) {
          A(nca(x + 1, y - 1, beta, alfa, tau, lam, pi))
        } else {
          0
        }

        math.max(commonLength, math.max(R(x) - i, A(y) - R(y) + j + 1))
      }

      results += z
    }

    results
  }

  def main(args: Array[String]): Unit = {
    // Hard-coded test data
    val testCases = List(
      TestCase(
        10,
        Array(-1, -1, 1, 1, 1, 1, 3, 10, 10, 10),
        Array(Array(2, 3), Array(1, 10), Array(5, 10)),
        Array(1, 4, 3)
      )
    )

    for ((test, idx) <- testCases.zipWithIndex) {
      val n = test.n
      val values = test.values
      val queries = test.queries
      val expected = test.expected

      println(s"Test Case ${idx + 1}:")
      println(s"Size: $n, Queries: ${queries.length}")
      print("Values: ")
      println(values.mkString(" "))

      val results = solve_test_case(n, values, queries)

      println("Queries and Results:")
      for (q_idx <- queries.indices) {
        val query = queries(q_idx)
        val result = results(q_idx)
        val exp = expected(q_idx)

        println(s"Query: ${query(0)} ${query(1)}")
        println(s"Result: $result (Expected: $exp)")
        if (result != exp) {
          println("  WARNING: Result doesn't match expected output")
        }
      }

      println()
    }
  }
}
