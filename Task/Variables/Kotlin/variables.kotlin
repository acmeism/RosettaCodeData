// version 1.0.6

fun main(args: Array<String>) {
    /* read-only variables */
    val i = 3          // type inferred to be Int
    val d = 2.4        // type inferred to be double
    val sh: Short = 2  // type specified as Short
    val ch = 'A'       // type inferred to be Char
    val bt: Byte = 1   // type specified as Byte

    /* mutable variables */
    var s = "Hey"      // type inferred to be String
    var l =  4L        // type inferred to be Long
    var b: Boolean     // type specified as Boolean, not initialized immediately
    var f =  4.4f      // type inferred to be Float

    b = true           // now initialized
    println("$i, $d, $sh, $ch, $bt, $s, $l, $b, $f")

    s = "Bye"          // OK as mutable
    l = 5L             // OK as mutable
    b = false          // OK as mutable
    f = 5.6f           // OK as mutable

    println("$i, $d, $sh, $ch, $bt, $s, $l, $b, $f")
}
