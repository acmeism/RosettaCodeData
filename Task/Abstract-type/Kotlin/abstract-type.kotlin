// version 1.1

interface Announcer {
    fun announceType()

    // interface can contain non-abstract members but cannot store state
    fun announceName() {
        println("I don't have a name")
    }
}

abstract class Animal: Announcer {
    abstract fun makeNoise()

    // abstract class can contain non-abstract members
    override fun announceType() {
        println("I am an Animal")
    }
}

class Dog(private val name: String) : Animal() {
    override fun makeNoise() {
       println("Woof!")
    }

    override fun announceName() {
       println("I'm called $name")
    }
}

class Cat: Animal() {
    override fun makeNoise() {
       println("Meow!")
    }

    override fun announceType() {
       println("I am a Cat")
    }
}

fun main(args: Array<String>) {
    val d = Dog("Fido")
    with(d) {
        makeNoise()
        announceType()  // inherits Animal's implementation
        announceName()
    }
    println()
    val c = Cat()
    with(c) {
        makeNoise()
        announceType()
        announceName()  // inherits Announcer's implementation
   }
}
