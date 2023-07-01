// The Kotlin compiler can detect expressions of signed constant integers that will overflow.
// It cannot detect unsigned integer overflow, however.
@Suppress("INTEGER_OVERFLOW")
fun main() {
    println("*** Signed 32 bit integers ***\n")
    println(-(-2147483647 - 1))
    println(2000000000 + 2000000000)
    println(-2147483647 - 2147483647)
    println(46341 * 46341)
    println((-2147483647 - 1) / -1)
    println("\n*** Signed 64 bit integers ***\n")
    println(-(-9223372036854775807 - 1))
    println(5000000000000000000 + 5000000000000000000)
    println(-9223372036854775807 - 9223372036854775807)
    println(3037000500 * 3037000500)
    println((-9223372036854775807 - 1) / -1)
    println("\n*** Unsigned 32 bit integers ***\n")
//    println(-4294967295U) // this is a compiler error since unsigned integers have no negation operator
//    println(0U - 4294967295U) // this works
    println((-4294967295).toUInt()) // converting from the signed Int type also produces the overflow; this is intended behavior of toUInt()
    println(3000000000U + 3000000000U)
    println(2147483647U - 4294967295U)
    println(65537U * 65537U)
    println("\n*** Unsigned 64 bit integers ***\n")
    println(0U - 18446744073709551615U) // we cannot convert from a signed type here (since none big enough exists) and have to use subtraction
    println(10000000000000000000U + 10000000000000000000U)
    println(9223372036854775807U - 18446744073709551615U)
    println(4294967296U * 4294967296U)
}
