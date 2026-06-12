interface Quaternion guards QS {}
def makeQuaternion(a, b, c, d) {
    return def quaternion implements QS {

        to __printOn(out) {
            out.print("(", a, " + ", b, "i + ")
            out.print(c, "j + ", d, "k)")
        }

        # Task requirement 1
        to norm() {
            return (a**2 + b**2 + c**2 + d**2).sqrt()
        }

        # Task requirement 2
        to negate() {
            return makeQuaternion(-a, -b, -c, -d)
        }

        # Task requirement 3
        to conjugate() {
            return makeQuaternion(a, -b, -c, -d)
        }

        # Task requirement 4, 5
        # This implements q + r; r + q is deliberately prohibited by E
        to add(other :any[Quaternion, int, float64]) {
            switch (other) {
              match q :Quaternion {
                return makeQuaternion(
                    a+q.a(), b+q.b(), c+q.c(), d+q.d())
              }
              match real {
                return makeQuaternion(a+real, b, c, d)
              }
            }
        }

        # Task requirement 6, 7
        # This implements q * r; r * q is deliberately prohibited by E
        to multiply(other :any[Quaternion, int, float64]) {
            switch (other) {
                match q :Quaternion {
                    return makeQuaternion(
                        a*q.a() - b*q.b() - c*q.c() - d*q.d(),
                        a*q.b() + b*q.a() + c*q.d() - d*q.c(),
                        a*q.c() - b*q.d() + c*q.a() + d*q.b(),
                        a*q.d() + b*q.c() - c*q.b() + d*q.a())
                    }
                match real {
                    return makeQuaternion(real*a, real*b, real*c, real*d)
                }
            }
        }

        to a() { return a }
        to b() { return b }
        to c() { return c }
        to d() { return d }
    }
}
