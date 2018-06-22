// Kotlin Native v0.5

import kotlinx.cinterop.*

fun main(args: Array<String>) {
    memScoped {
        val intVar1 = alloc<IntVar>()
        intVar1.value = 1
        val intVar2 = alloc<IntVar>()
        intVar2.value = 2
        println("${intVar1.value} + ${intVar2.value} = ${intVar1.value + intVar2.value}")
    }
    // native memory used by intVar1 & intVar2 is automatically freed when memScoped block ends
}
