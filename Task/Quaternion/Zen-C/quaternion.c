import "std/math.zc"

struct Quaternion {
    a: f64;
    b: f64;
    c: f64;
    d: f64;
}

impl Quaternion {
    fn new(a: f64, b: f64, c: f64, d: f64) -> Self {
        return Quaternion{a: a, b: b, c: c, d: d};
    }

    fn norm(self) -> f64 {
        return Math::sqrt(.a * .a + .b * .b + .c * .c + .d * .d);
    }

    fn neg(self) -> Quaternion {
        return Quaternion{a: -.a, b: -.b, c: -.c, d: -.d};
    }

    fn conj(self) -> Quaternion {
        return Quaternion{a: .a, b: -.b, c: -.c, d: -.d};
    }

    fn add(self, q: Quaternion) -> Quaternion {
        return Quaternion{a: .a + q.a, b: .b + q.b, c: .c + q.c, d: .d + q.d};
    }

    fn add_real(self, r: f64) -> Quaternion {
        return Quaternion{a: .a + r, b: .b, c: .c, d: .d};
    }

    fn mul(self, q: Quaternion) -> Quaternion {
        return Quaternion{
              a: .a * q.a - .b * q.b - .c * q.c - .d * q.d,
              b: .a * q.b + .b * q.a + .c * q.d - .d * q.c,
              c: .a * q.c - .b * q.d + .c * q.a + .d * q.b,
              d: .a * q.d + .b * q.c - .c * q.b + .d * q.a
        };
    }

    fn mul_real(self, r: f64) -> Quaternion {
        return Quaternion{a: .a * r, b: .b * r, c: .c * r, d: .d * r};
    }

    fn eq(self, q: Quaternion) -> bool {
        return .a == q.a && .b == q.b && .c == q.c && .d == q.d;
    }

    fn neq(self, q: Quaternion) -> bool {
        return !self.eq(q);
    }

    fn to_string(self) -> string {
        return "({self.a:g}, {self.b:g}, {self.c:g}, {self.d:g})";
    }

    // static functions

    fn real_add(r: f64, q: Quaternion) -> Quaternion {
       return q.add_real(r);
    }

    fn real_mul(r: f64, q: Quaternion) -> Quaternion {
       return q.mul_real(r);
    }
}

fn btos(b: bool) -> string {
    return b ? "true" : "false";
}

fn main() {
    let q  = Quaternion::new(1.0, 2.0, 3.0, 4.0);
    let q1 = Quaternion::new(2.0, 3.0, 4.0, 5.0);
    let q2 = Quaternion::new(3.0, 4.0, 5.0, 6.0);
    let q3 = q1 * q2;
    let q4 = q2 * q1;
    let r = 7.0;

    println "q           = {q}";
    println "q1          = {q1}";
    println "q2          = {q2}";
    println "r           = {r:g}";
    println "norm(q)     = {q.norm():0.14f}";
    println "-q          = {-q}";
    println "conj(q)     = {q.conj()}";
    println "r + q       = {Quaternion::real_add(r, q)}";
    println "q + r       = {q.add_real(r)}";
    println "q1 + q2     = {q1 + q2}";
    println "q2 + q1     = {q2 + q1}";
    println "rq          = {Quaternion::real_mul(r, q)}";
    println "qr          = {q.mul_real(r)}";
    println "q1q2        = {q3}";
    println "q2q1        = {q4}";
    println "q1q2 ≠ q2q1 = {btos(q3 != q4)}";
}
