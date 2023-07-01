var tol = 1e-16
var pairs = [
    [100000000000000.01, 100000000000000.011],
    [100.01, 100.011],
    [10000000000000.001 / 10000.0, 1000000000.0000001000],
    [0.001, 0.0010000001],
    [0.000000000000000000000101, 0.0],
    [2.sqrt * 2.sqrt, 2.0],
    [-2.sqrt * 2.sqrt, -2.0],
    [3.14159265358979323846, 3.14159265358979324]
]
System.print("Approximate equality of test cases for a tolerance of %(tol):")
var i = 0
for (pair in pairs) {
    i = i + 1
    System.print("  %(i) -> %((pair[0] - pair[1]).abs < tol)")
}
