/* Host_introspection.wren */

class C {
    foreign static wordSize
    foreign static endianness
}

System.print("word size  = %(C.wordSize) bits")
System.print("endianness = %(C.endianness)")
