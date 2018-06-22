// version 1.1.51

interface Thingable {
    fun thing(): String?
}

class Delegate(val responds: Boolean) : Thingable {
    override fun thing() = if (responds) "delegate implementation" else null
}

class Delegator(d: Delegate) : Thingable by d {
    fun operation() = thing() ?: "default implementation"
}

fun main(args: Array<String>) {
    // delegate doesn't respond to 'thing'
    val d = Delegate(false)
    val dd = Delegator(d)
    println(dd.operation())

    // delegate responds to 'thing'
    val d2 = Delegate(true)
    val dd2 = Delegator(d2)
    println(dd2.operation())
}
