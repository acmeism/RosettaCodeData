import "std/math.zc"

alias deriv = fn*(f64, f64) -> f64;

fn euler(f: deriv, y: f64, step: int, end: int) {
    let t = 0;
    print " Step {step:2d}: ";
    do {
        if !(t % 10) { print " {y:7.3f}"; }
        y += step * f(t, y);
        t += step;
    } while t <= end;
    println "";
}

fn analytic() {
    print "    Time: ";
    for let t = 0; t <= 100; t += 10 { print " {(f64)t:7g}"; }
    print "\nAnalytic: ";
    for let t = 0; t <= 100; t += 10 {
        let v = 20.0 + 80.0 * Math::exp(-0.07 * (f64)t);
        print " {v:7.3f}";
    }
    println "";
}

fn cooling(_: f64, temp: f64) -> f64 {
    return -0.07 * (temp - 20.0);
}

fn main() {
    analytic();
    euler(cooling, 100, 2, 100);
    euler(cooling, 100, 5, 100);
    euler(cooling, 100, 10, 100);
}
