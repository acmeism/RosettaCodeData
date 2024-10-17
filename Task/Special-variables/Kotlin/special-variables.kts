// version 1.0.6

class President(val name: String) {
    var age: Int = 0
        set(value) {
           if (value in 0..125) field = value  // assigning to backing field here
           else throw IllegalArgumentException("$name's age must be between 0 and 125")
        }
}

fun main(args: Array<String>) {
    val pres = President("Donald")
    pres.age = 69
    val pres2 = President("Jimmy")
    pres2.age = 91
    val presidents = mutableListOf(pres, pres2)
    presidents.forEach {
        it.age++  // 'it' is implicit sole parameter of lambda expression
        println("President ${it.name}'s age is currently ${it.age}")
    }
    println()
    val pres3 = President("Theodore")
    pres3.age = 158
}
