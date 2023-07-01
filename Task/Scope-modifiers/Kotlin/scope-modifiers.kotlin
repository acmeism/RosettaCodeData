// version 1.1.2

class SomeClass {
    val id: Int

    companion object {
        private var lastId = 0
        val objectsCreated get() = lastId
    }

    init {
        id = ++lastId
    }
}

fun main(args: Array<String>) {
    val sc1 = SomeClass()
    val sc2 = SomeClass()
    println(sc1.id)
    println(sc2.id)
    println(SomeClass.objectsCreated)
}
