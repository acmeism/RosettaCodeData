// version 1.1.2

class MyClass(val myInt: Int) {
    // in theory this method should be called automatically prior to GC
    protected fun finalize() {
        println("MyClass being finalized...")
    }
}

fun myFun() {
    val mc: MyClass = MyClass(2)   // new non-nullable MyClass object allocated on the heap
    println(mc.myInt)
    var mc2: MyClass? = MyClass(3) // new nullable MyClass object allocated on the heap
    println(mc2?.myInt)
    mc2 = null                     // allowed as mc2 is nullable
    println(mc2?.myInt)
    // 'mc' and 'mc2' both become eligible for garbage collection here as no longer used
}

fun main(args: Array<String>) {
    myFun()
    Thread.sleep(3000)  // allow time for GC to execute
    val i: Int  = 4     // new non-nullable Int allocated on stack
    println(i)
    var j: Int? = 5     // new nullable Int allocated on heap
    println(j)
    j = null            // allowed as 'j' is nullable
    println(j)
    // 'j' becomes eligible for garbage collection here as no longer used
}
