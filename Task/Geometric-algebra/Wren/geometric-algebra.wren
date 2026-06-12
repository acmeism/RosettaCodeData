import "random" for Random

var bitCount = Fn.new { |i|
    i = i - ((i >> 1) & 0x55555555)
    i = (i & 0x33333333) + ((i >> 2) & 0x33333333)
    i = (i + (i >> 4)) & 0x0f0f0f0f
    i = i + (i >> 8)
    i = i + (i >> 16)
    return i & 0x0000003F
}

var ReorderingSign = Fn.new { |i, j|
    var k = i >> 1
    var sum = 0
    while (k != 0) {
        sum = sum + bitCount.call(k & j)
        k = k >> 1
    }
    return (sum & 1 == 0) ? 1 : -1
}

class Vector {
    construct new(dims) {
        _dims = dims
    }

    dims { _dims }

    dot(rhs) { (this * rhs + rhs * this) * 0.5 }

    - { this * -1 }

    +(rhs) {
        var result = List.filled(32, 0)
        for (i in 0..._dims.count) result[i] = _dims[i]
        for (i in 0...rhs.dims.count) result[i] = result[i] + rhs[i]
        return Vector.new(result)
    }

    *(rhs) {
        if (rhs is Vector) {
            var result = List.filled(32, 0)
            for (i in 0..._dims.count) {
                if (_dims[i] != 0) {
                    for (j in 0...rhs.dims.count) {
                        if (rhs[j] != 0) {
                            var s = ReorderingSign.call(i, j) * _dims[i] * rhs[j]
                            var k = i ^ j
                            result[k] = result[k] + s
                        }
                    }
                }
            }
            return Vector.new(result)
        } else if (rhs is Num) {
            var result = _dims.toList
            for (i in 0..4) dims[i] = dims[i] * rhs
            return Vector.new(result)
        } else {
            Fiber.abort("rhs must either be a Vector or a number")
        }
    }

    [index] { _dims[index] }

    [index]=(value) { _dims[index] = value }

    toString { "(" + _dims.join(", ") + ")" }
}

var e = Fn.new { |n|
    if (n > 4) Fiber.abort("n must be less than 5")
    var result = Vector.new(List.filled(32, 0))
    result[1 << n] = 1
    return result
}

var rand = Random.new()

var randomVector = Fn.new {
    var result = Vector.new(List.filled(32, 0))
    for (i in 0..4) {
        result = result + Vector.new([rand.float()]) * e.call(i)
    }
    return result
}

var randomMultiVector = Fn.new {
    var result = Vector.new(List.filled(32, 0))
    for (i in 0..31) result[i] = rand.float()
    return result
}

for (i in 0..4) {
    for (j in 0..4) {
        if (i < j) {
            if (e.call(i).dot(e.call(j))[0] != 0) {
                System.print("Unexpected non-null scalar product.")
                return
            } else if (i == j) {
                if (e.call(i).dot(e.call(j))[0] == 0) {
                    System.print("Unexpected null scalar product.")
                }
            }
        }
    }
}

var a = randomMultiVector.call()
var b = randomMultiVector.call()
var c = randomMultiVector.call()
var x = randomVector.call()

// (ab)c == a(bc)
System.print((a * b) * c)
System.print(a * (b * c))
System.print()

// a(b+c) == ab + ac
System.print(a * (b + c))
System.print(a * b + a * c)
System.print()

// (a+b)c == ac + bc
System.print((a + b) * c)
System.print(a * c + b * c)
System.print()

// x^2 is real
System.print(x * x)
