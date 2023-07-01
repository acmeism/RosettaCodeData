// version 1.0.6 (intro.kt)

import java.lang.reflect.Method

val bloop = -3
val i = 4
val j = 5
val k = 6

fun main(args: Array<String>) {
    // get version of JVM
    val version = System.getProperty("java.version")
    if (version >= "1.6") println("The current JVM version is $version")
    else println("Must use version 1.6 or later")

    // check that 'bloop' and 'Math.abs' are available
    // note that the class created by the Kotlin compiler for top level declarations will be called 'IntroKt'
    val topLevel = Class.forName("IntroKt")
    val math = Class.forName("java.lang.Math")
    val abs = math.getDeclaredMethod("abs", Int::class.java)
    val methods = topLevel.getDeclaredMethods()
    for (method in methods) {
        // note that the read-only Kotlin property 'bloop' is converted to the static method 'getBloop' in Java
        if (method.name == "getBloop" && method.returnType == Int::class.java) {
            println("\nabs(bloop) = ${abs.invoke(null, method.invoke(null))}")
            break
        }
    }

    // now get the number of global integer variables and their sum
    var count = 0
    var sum = 0
    for (method in methods) {
        if (method.returnType == Int::class.java) {
            count++
            sum += method.invoke(null) as Int
        }
    }
    println("\nThere are $count global integer variables and their sum is $sum")
}
