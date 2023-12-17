transparent inline def factorial(inline n: Int): Int =
  inline n match
    case 0 => 1
    case _ => n * factorial(n - 1)

inline val factorial10/*: 3628800*/ = factorial(10)
