// version 1.1.0

//  constant top level property
const val N = 5

//  read-only top level property
val letters = listOf('A', 'B', 'C', 'D', 'E') // 'listOf' creates here a List<Char) which is immutable

class MyClass {  // MyClass is effectively immutable because it's only property is read-only
                 // and it is not 'open' so cannot be sub-classed
    // read-only class property
    val myInt = 3

    fun myFunc(p: Int) {  // parameter 'p' is read-only
        var pp = p        // local variable 'pp' is mutable
        while (pp < N) {  // compiler will change 'N' to 5
            print(letters[pp++])
        }
        println()
    }
}

fun main(args: Array<String>) {
    val mc = MyClass()   // 'mc' cannot be re-assigned a different object
    println(mc.myInt)
    mc.myFunc(0)
}
