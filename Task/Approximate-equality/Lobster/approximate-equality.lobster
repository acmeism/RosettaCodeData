// Return whether the two numbers `a` and `b` are close.
// Closeness is determined by the `epsilon` parameter -
// the numbers are considered close if the difference between them
// is no more than epsilon * max(abs(a), abs(b)).
//
def isclose(a, b, epsilon):
    return abs(a - b) <= max(abs(a), abs(b)) * epsilon

let tv = [
    xy { 100000000000000.01, 100000000000000.011 },
    xy { 100.01, 100.011 },
    xy { 10000000000000.001 / 10000.0, 1000000000.0000001000 },
    xy { 0.001, 0.0010000001 },
    xy { 0.000000000000000000000101, 0.0 },
    xy { sqrt(2.0) * sqrt(2.0), 2.0 },
    xy { -sqrt(2.0) * sqrt(2.0), -2.0 },
    xy { 3.14159265358979323846, 3.14159265358979324 }
    ]

for(tv) t:
    print concat_string([string(t.x), if isclose(t.x, t.y, 1.0e-9): """ ≈ """ else: """ ≉ """, string(t.y)], "")
