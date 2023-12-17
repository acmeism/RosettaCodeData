import "./fmt" for Fmt

class Sandpile {
    static init() {
        __neighbors = [
            [1, 3], [0, 2, 4], [1, 5], [0, 4, 6], [1, 3, 5, 7], [2, 4, 8], [3, 7], [4, 6, 8], [5, 7]
        ]
    }

    // 'a' is a list of 9 integers in row order
    construct new(a) {
        _a = a
    }

    a { _a }

    +(other) {
        var b = List.filled(9, 0)
        for (i in 0..8) b[i] = _a[i] + other.a[i]
        return Sandpile.new(b)
    }

    isStable { _a.all { |i| i <= 3 } }

    // just topples once so we can observe intermediate results
    topple() {
        for (i in 0..8) {
            if (_a[i] > 3) {
                _a[i] = _a[i] - 4
                for (j in __neighbors[i]) _a[j] = _a[j] + 1
                return
            }
        }
    }

    toString {
        var s = ""
        for (i in 0..2) {
            for (j in 0..2) s = s + "%(a[3*i + j]) "
            s = s + "\n"
        }
        return s
    }
}

Sandpile.init()
System.print("Avalanche of topplings:\n")
var s4 = Sandpile.new([4, 3, 3, 3, 1, 2, 0, 2, 3])
System.print(s4)
while (!s4.isStable) {
    s4.topple()
    System.print(s4)
}

System.print("Commutative additions:\n")
var s1 = Sandpile.new([1, 2, 0, 2, 1, 1, 0, 1, 3])
var s2 = Sandpile.new([2, 1, 3, 1, 0, 1, 0, 1, 0])
var s3_a = s1 + s2
while (!s3_a.isStable) s3_a.topple()
var s3_b = s2 + s1
while (!s3_b.isStable) s3_b.topple()
Fmt.print("$s\nplus\n\n$s\nequals\n\n$s", s1, s2, s3_a)
Fmt.print("and\n\n$s\nplus\n\n$s\nalso equals\n\n$s", s2, s1, s3_b)

System.print("Addition of identity sandpile:\n")
var s3 = Sandpile.new(List.filled(9, 3))
var s3_id = Sandpile.new([2, 1, 2, 1, 0, 1, 2, 1, 2])
s4 = s3 + s3_id
while (!s4.isStable) s4.topple()
Fmt.print("$s\nplus\n\n$s\nequals\n\n$s", s3, s3_id, s4)

System.print("Addition of identities:\n")
var s5 = s3_id + s3_id
while (!s5.isStable) s5.topple()
Fmt.write("$s\nplus\n\n$s\nequals\n\n$s", s3_id, s3_id, s5)
