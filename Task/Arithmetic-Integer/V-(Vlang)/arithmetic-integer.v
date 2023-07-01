// Arithmetic-integer in V (Vlang)
// Tectonics: v run arithmetic-integer.v
module main
import math
import os

// starts here
pub fn main() {
    mut a := 0
    mut b := 0

    // get numbers from console
    print("Enter two integer numbers, separated by a space: ")
    text := os.get_raw_line()
    values := text.split(' ')
    a = values[0].int()
    b = values[1].int()

    // 4 basics, remainder, no exponentiation operator
    println("values:           a $a, b $b")
    println("sum:              a + b = ${a + b}")
    println("difference:       a - b = ${a - b}")
    println("product:          a * b = ${a * b}")
    println("integer quotient: a / b = ${a / b}, truncation")
    println("remainder:        a % b = ${a % b}, sign follows dividend")

    println("no exponentiation operator")
    println("  math.pow:    pow(a,b) = ${math.pow(a,b)}")
}
