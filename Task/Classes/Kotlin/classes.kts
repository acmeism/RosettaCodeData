class MyClass(val myInt: Int) {
   fun treble(): Int = myInt * 3
}

fun main(args: Array<String>) {
    val mc = MyClass(24)
    print("${mc.myInt}, ${mc.treble()}")
}
