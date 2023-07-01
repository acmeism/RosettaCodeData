import math.complex
fn main() {
    a := complex.complex(1, 1)
    b := complex.complex(3.14159, 1.25)
    println("a:      $a")
    println("b:      $b")
    println("a + b:  ${a+b}")
    println("a * b:  ${a*b}")
    println("-a:     ${a.addinv()}")
    println("1 / a:  ${complex.complex(1,0)/a}")
    println("a̅:      ${a.conjugate()}")
}
