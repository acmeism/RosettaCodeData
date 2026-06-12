package main

import "fmt"

func main() {
    // 1 and 2 are untyped integer constants with a default type of int.

    // Here a local variable 'i' is created and explicitly given the type int32.
    // 1 implicitly assumes this type which is consistent with its representation.
    var i int32 = 1
    fmt.Printf("i : type %-7T value %d\n", i, i)

    // Here a local variable 'j' is created and implicitly given the type int.
    // In the absence of any type information, 2 adopts its default type of int
    // and the type of 'j' is therefore inferred to be 'int' also.
    j := 2
    fmt.Printf("j : type %-7T value %d\n", j, j)

    // Here 'k' is declared to be an int64 variable and it can only therefore be initialized
    // with an expression of the same type. As 'i' and 'j' have respective types of int32
    // and int, they need to be explicitly converted to int64 so that, first the addition and
    // second the assignment compile.
    var k int64 = int64(i) + int64(j)
    fmt.Printf("k : type %-7T value %d\n", k, k)

    // 4.0 is an untyped floating point constant with a default type of float64. However,
    // (unusually in my experience of other strongly typed languages) it can also represent
    // an integer type because it happens to be a whole number.

    // Here 'l' is declared to be an int8 variable and it can only therefore be initialized
    // with an expression of the same type. As noted above 4.0 can represent this type and
    // so the following compiles fine.
    var l int8 = 4.0
    fmt.Printf("l : type %-7T value %d\n", l, l)

    // Here 'm' is created and implicitly given the type float64 because the expression on
    // the RHS is of that type. Note that 'l' needs to be converted to this type before it
    // can be added to the untyped floating point constants 0.3 and 0.7.
    m := 0.3 + float64(l) + 0.7
    fmt.Printf("m : type %-7T value %g\n", m, m)
}
