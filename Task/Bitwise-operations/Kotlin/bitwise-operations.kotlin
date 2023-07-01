fun main() {
    // inferred type of x and y is Int (32-bit signed integer)
    val x = 10
    val y = 2
    println("x = $x")
    println("y = $y")
    println("NOT x = ${x.inv()}")
    println("x AND y = ${x and y}")
    println("x OR y = ${x or y}")
    println("x XOR y = ${x xor y}")

    // All operations below actually return (x OP (y % 32)) so that a value is never completely shifted out
    println("x SHL y = ${x shl y}")
    println("x ASR y = ${x shr y}") // arithmetic shift right (sign bit filled)
    println("x LSR y = ${x ushr y}") // logical shift right (zero filled)
    println("x ROL y = ${x.rotateLeft(y)}")
    println("x ROR y = ${x.rotateRight(y)}")
}
