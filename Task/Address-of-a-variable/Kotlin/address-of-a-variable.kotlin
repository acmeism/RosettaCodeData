// Kotlin Native v0.5

import kotlinx.cinterop.*

fun main(args: Array<String>) {
    val intVar = nativeHeap.alloc<IntVar>()
    intVar.value = 42
    with(intVar) { println("Value is $value, address is $rawPtr") }
    nativeHeap.free(intVar)
}
