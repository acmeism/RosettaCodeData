fun main() {
    // signed integer literals
    val d = 255                // decimal
    val h = 0xff               // hexadecimal (can use 0X instead of 0x)
    val b = 0b11111111         // binary (can use 0B instead of 0b)

    // signed long integer literals (cannot use l instead of L)
    val ld = 255L              // decimal
    val lh = 0xffL             // hexadecimal
    val lb = 0b11111111L       // binary

    // unsigned integer literals (can use U instead of u)
    val ud = 255u              // decimal
    val uh = 0xffu             // hexadecimal
    val ub = 0b11111111u       // binary

    // unsigned long integer literals (can use U instead of u)
    val uld = 255uL             // decimal
    val ulh = 0xffuL            // hexadecimal
    val ulb = 0b11111111uL      // binary

    // implicit conversions
    val ld2 = 2147483648        // decimal signed integer literal automatically converted to Long since it cannot fit into an Int
    val ush : UShort = 0x7fu    // hexadecimal unsigned integer literal automatically converted to UShort
    val bd : Byte  = 0b01111111 // binary signed integer literal automatically converted to Byte

    println("$d $h $b $ud $uh $ub $ld $lh $lb $uld $ulh $ulb $ld2 $ush $bd")
}
