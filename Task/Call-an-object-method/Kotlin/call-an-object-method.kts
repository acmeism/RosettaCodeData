class MyClass {
    fun instanceMethod(s: String) = println(s)

    companion object {
        fun staticMethod(s: String) = println(s)
    }
}

fun main() {
    val mc = MyClass()
    mc.instanceMethod("Hello instance world!")
    MyClass.staticMethod("Hello static world!")
}
