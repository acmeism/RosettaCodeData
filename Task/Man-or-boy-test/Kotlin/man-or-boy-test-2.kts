// version 2.3.10

data class State(
  val k: Int,
  val x1: Func,
  val x2: Func,
  val x3: Func,
  val x4: Func,
  val x5: Func,
)

typealias Func = suspend DeepRecursiveScope<State, Int>.() -> Int

val a = DeepRecursiveFunction<State, Int> { s ->
  with(s) {
    var k = k

    suspend fun DeepRecursiveScope<State, Int>.b(): Int {
      k -= 1
      return callRecursive(State(k, { b() }, x1, x2, x3, x4))
    }

    if (k <= 0) x4() + x5() else b()
  }
}

fun main() {
  repeat(21) { k ->
    val result =
      a(
        State(
          k = k,
          x1 = { 1 },
          x2 = { -1 },
          x3 = { -1 },
          x4 = { 1 },
          x5 = { 0 },
        )
      )

    println("$k".padStart(2) + ": " + "$result".padStart(8))
  }
}
