import "std/complex.zc"
import "std/string.zc"

fn negate(c: Complex) -> Complex {
    return Complex{real: -c.real, imag: -c.imag};
}

fn inverse(c: Complex) -> Complex {
    return Complex::new(1, 0) / c;
}

fn conjugate(c: Complex) -> Complex {
    return Complex{real: c.real, imag: -c.imag};
}

fn cstr(c: Complex) -> String {
    let rsign = c.real < 0 ? "-" : " ";
    let isign = c.imag < 0 ? "-" : "+";
    let s = "{rsign}{fabs(c.real):g} {isign} {fabs(c.imag):g}i";
    return String::from(s);
}

fn main() {
    let x = Complex::new(1.0, 3.0);
    let y = Complex::new(5.0, 2.0);
    println "x     =  {cstr(x)}";
    println "y     =  {cstr(y)}";
    println "x + y =  {cstr(x + y)}";
    println "x - y =  {cstr(x - y)}";
    println "x * y =  {cstr(x * y)}";
    println "x / y =  {cstr(x / y)}";
    println "-x    =  {cstr(negate(x))}";
    println "1 / x =  {cstr(inverse(x))}";
    println "x*    =  {cstr(conjugate(x))}";
}
