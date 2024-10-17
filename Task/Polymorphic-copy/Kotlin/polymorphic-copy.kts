// version 1.1.2

open class Animal(val name: String, var age: Int) {
    open fun copy() = Animal(name, age)

    override fun toString() = "Name: $name, Age: $age"
}

class Dog(name: String, age: Int, val breed: String) : Animal(name, age) {
    override fun copy() = Dog(name, age, breed)

    override fun toString() = super.toString() + ", Breed: $breed"
}

fun main(args: Array<String>) {
    val a: Animal = Dog("Rover", 3, "Terrier")
    val b: Animal = a.copy()  // calls Dog.copy() because runtime type of 'a' is Dog
    println("Dog 'a' = $a")   // implicitly calls Dog.toString()
    println("Dog 'b' = $b")   // ditto
    println("Dog 'a' is ${if (a === b) "" else "not"} the same object as Dog 'b'")
}
