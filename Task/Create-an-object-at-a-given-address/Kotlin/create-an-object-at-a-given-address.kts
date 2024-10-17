// Kotlin/Native Technology Preview

import kotlinx.cinterop.*

fun main(args: Array<String>) {
    val intVar = nativeHeap.alloc<IntVar>().apply { value = 42 }
    with(intVar) { println("Value is $value, address is $rawPtr") }
    intVar.value = 52  // create new value at this address
    with(intVar) { println("Value is $value, address is $rawPtr") }
    nativeHeap.free(intVar)
}
