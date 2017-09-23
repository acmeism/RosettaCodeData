// version 1.0.6

open class Animal {
    override fun toString() = "animal"
}

open class Dog : Animal() {
    override fun toString() = "dog"
}

class Cat : Animal() {
    override fun toString() = "cat"
}

class Labrador : Dog() {
    override fun toString() = "labrador"
}

class Collie : Dog() {
    override fun toString() = "collie"
}

fun main(args: Array<String>) {
    val felix: Animal = Cat()
    val rover: Animal = Dog()
    val bella: Dog = Labrador()
    val casey: Dog = Collie()
    println("Felix is a $felix")
    println("Rover is a $rover")
    println("Bella is a $bella")
    println("Casey is a $casey")
}
