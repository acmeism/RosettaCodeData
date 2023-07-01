import math

fn main() {
    mut sum := 0.0
    mut prod :=1.0
    mut recip_sum := 0.0
    n := 10

    for val in 1..(n + 1) {
        sum += val
        prod *= val
        recip_sum = recip_sum + ( 1.0 / val )
    }

    a := sum / n
    g := math.pow( prod, ( 1.0 / f32(n) ) )
    h := n / recip_sum

    result := 'Arithmetic Mean: ${a:3.2f} \nGeometric Mean: ${g:3.2f}\nHarmonic Mean: ${h:3.2f}'
    println( result )

    compare := if a >= g && g >= h { "Yes" } else { "Nope" }
    println('Is A >= G >= H? $compare')
}
