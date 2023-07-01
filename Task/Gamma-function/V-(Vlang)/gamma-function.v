import math
fn main() {
    println("    x               math.Gamma                 Lanczos7")
    for x in [-.5, .1, .5, 1, 1.5, 2, 3, 10, 140, 170] {
        println("${x:5.1f} ${math.gamma(x):24.16} ${lanczos7(x):24.16}")
    }
}

fn lanczos7(z f64) f64 {
    t := z + 6.5
    x := .99999999999980993 +
        676.5203681218851/z -
        1259.1392167224028/(z+1) +
        771.32342877765313/(z+2) -
        176.61502916214059/(z+3) +
        12.507343278686905/(z+4) -
        .13857109526572012/(z+5) +
        9.9843695780195716e-6/(z+6) +
        1.5056327351493116e-7/(z+7)
    return math.sqrt2 * math.sqrt_pi * math.pow(t, z-.5) * math.exp(-t) * x
}
