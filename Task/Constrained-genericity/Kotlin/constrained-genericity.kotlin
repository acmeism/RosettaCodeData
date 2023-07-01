// version 1.0.6

interface Eatable {
    fun eat()
}

class Cheese(val name: String) : Eatable {
    override fun eat() {
       println("Eating $name")
    }

    override fun toString() = name
}

class Meat(val name: String) : Eatable {
    override fun eat() {
       println("Eating $name")
    }

    override fun toString() = name
}

class FoodBox<T: Eatable> {
    private val foodList =  mutableListOf<T>()

    fun add(food: T) {
        foodList.add(food)
    }

    override fun toString() = foodList.toString()
}

fun main(args: Array<String>) {
    val cheddar =  Cheese("cheddar")
    val feta = Cheese("feta")
    val cheeseBox = FoodBox<Cheese>()
    cheeseBox.add(cheddar)
    cheeseBox.add(feta)
    println("CheeseBox contains : $cheeseBox")

    val beef = Meat("beef")
    val ham = Meat("ham")
    val meatBox = FoodBox<Meat>()
    meatBox.add(beef)
    meatBox.add(ham)
    println("MeatBox contains : $meatBox")

    cheddar.eat()
    beef.eat()
    println("Full now!")
}
