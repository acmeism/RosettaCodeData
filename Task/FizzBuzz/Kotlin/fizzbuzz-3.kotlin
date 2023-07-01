fun fizzBuzz2() {
    fun fizz(x: Pair<Int, StringBuilder>) = if(x.first % 3 == 0) x.apply { second.append("Fizz") } else x
    fun buzz(x: Pair<Int, StringBuilder>) = if(x.first % 5 == 0) x.apply { second.append("Buzz") } else x
    fun none(x: Pair<Int, StringBuilder>) = if(x.second.isBlank()) x.second.apply { append(x.first) } else x.second

    (1..100).map { Pair(it, StringBuilder()) }
            .map { fizz(it) }
            .map { buzz(it) }
            .map { none(it) }
            .forEach { println(it) }
}
