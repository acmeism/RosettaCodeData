// Version 1.2.31

import kotlin.reflect.full.functions

open class MySuperClass {
    fun mySuperClassMethod(){}
}

open class MyClass : MySuperClass() {
    fun myPublicMethod(){}

    internal fun myInternalMethod(){}

    protected fun myProtectedMethod(){}

    private fun myPrivateMethod(){}
}

fun main(args: Array<String>) {
    val c = MyClass::class
    println("List of methods declared in ${c.simpleName} and its superclasses:\n")
    val fs = c.functions
    for (f in fs) println("${f.name}, ${f.visibility}")
}
