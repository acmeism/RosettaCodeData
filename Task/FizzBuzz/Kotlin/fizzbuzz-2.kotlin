fun fizzBuzz1() {
    fun fizzBuzz(x: Int) = if (x % 15 == 0) "FizzBuzz" else x.toString()
    fun fizz(x: Any) = if (x is Int && x % 3 == 0) "Buzz" else x
    fun buzz(x: Any) = if (x is Int && x.toInt() % 5 == 0) "Fizz" else x

    (1..100).map { fizzBuzz(it) }.map { fizz(it) }.map { buzz(it) }.forEach { println(it) }
}
