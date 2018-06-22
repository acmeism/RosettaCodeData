object PolymorphicCopy {

  def main(args: Array[String]) {
    val a: Animal = Dog("Rover", 3, "Terrier")
    val b: Animal = a.copy() // calls Dog.copy() because runtime type of 'a' is Dog
    println(s"Dog 'a' = $a") // implicitly calls Dog.toString()
    println(s"Dog 'b' = $b") // ditto
    println(s"Dog 'a' is ${if (a == b) "" else "not"} the same object as Dog 'b'")
  }

  case class Animal(name: String, age: Int) {

    override def toString = s"Name: $name, Age: $age"
  }

  case class Dog(override val name: String, override val age: Int, breed: String) extends Animal(name, age) {

    override def toString = super.toString() + s", Breed: $breed"
  }

}
