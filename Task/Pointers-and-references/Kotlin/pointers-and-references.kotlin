// Kotlin Native v0.3

import kotlinx.cinterop.*

fun main(args: Array<String>) {
    // allocate space for an 'int' on the native heap and wrap a pointer to it in an IntVar object
    val intVar: IntVar = nativeHeap.alloc<IntVar>()
    intVar.value = 3                 // set its value
    println(intVar.value)            // print it
    println(intVar.ptr)              // corresponding CPointer object
    println(intVar.rawPtr)           // the actual address wrapped by the CPointer

    // change the value and print that
    intVar.value = 333
    println()
    println(intVar.value)
    println(intVar.ptr)              // same as before, of course

    // implicitly convert to an opaque pointer which is the supertype of all pointer types
    val op: COpaquePointer = intVar.ptr

    // cast opaque pointer to a pointer to ByteVar
    println()
    var bytePtr: CPointer<ByteVar> = op.reinterpret<ByteVar>()
    println(bytePtr.pointed.value)   // value of first byte i.e. 333 - 256 = 77 on Linux
    bytePtr = (bytePtr + 1)!!        // increment pointer
    println(bytePtr.pointed.value)   // value of second byte i.e. 1 on Linux
    println(bytePtr)                 // one byte more than before
    bytePtr = (bytePtr + (-1))!!     // decrement pointer
    println(bytePtr)                 // back to original value
    nativeHeap.free(intVar)          // free native memory

    // allocate space for an array of 3 'int's on the native heap
    println()
    var intArray: CPointer<IntVar> = nativeHeap.allocArray<IntVar>(3)
    for (i in 0..2) intArray[i] = i  // set them
    println(intArray[2])             // print the last element
    nativeHeap.free(intArray)        // free native memory
}
