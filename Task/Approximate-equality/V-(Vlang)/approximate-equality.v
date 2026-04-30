import math

fn aeq(a f64, b f64) bool {
    return math.abs(a - b) <= math.abs(a) * 1e-14
}

fn test(a f64, b f64) {
    print("${a} ${b} -> ")
    if aeq(a, b) { println("true") }
	else { println("false") }
}

fn main() {
    test(100000000000000.01, 100000000000000.011)
    test(100.01, 100.011)
    test(10000000000000.001 / 10000, 1000000000.0000001)
    test(0.001, 0.0010000001)
    test(1.01e-22, 0)
    test(math.sqrt(2) * math.sqrt(2), 2)
    test(-math.sqrt(2) * math.sqrt(2), -2)
    test(3.14159265358979323846, 3.14159265358979324)
}
