import "std/math.zc"

fn main() {
    def EPS = 1e-15;
    let e = 2.0;
    let fact: u64 = 1;
    let n: u64 = 2;
    loop {
        let e0 = e;
        fact *= n++;
        e += 1.0 / (f64)fact;
        if Math::abs(e - e0) < EPS { break; }
    }
    println "e = {e:0.15f}";
}
