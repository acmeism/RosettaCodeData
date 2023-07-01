import "/fmt" for Fmt

// argument validation
var d = Fn.new { |b|
    if (b < 48 || b > 57) Fiber.abort("digit 0-9 expected")
    return b - 48
}

// converts a list of bytes to a string
var b2s = Fn.new { |b| b.map { |e| String.fromByte(e) }.join() }

// add two numbers as strings
var add = Fn.new { |x, y|
    if (y.count > x.count) {
        var t = x
        x = y
        y = t
    }
    var b = List.filled(x.count+1, 0)
    var c = 0
    for (i in 1..x.count) {
        if (i <= y.count) c = c + d.call(y[y.count-i].bytes[0])
        var s = d.call(x[x.count-i].bytes[0]) + c
        c = (s/10).floor
        b[b.count-i] = (s%10) + 48
    }
    if (c == 0) return b2s.call(b[1..-1])
    b[0] = c + 48
    return b2s.call(b)
}

// multiply a number by a single digit
var mulDigit = Fn.new { |x, y|
    if (y == 48) return "0"
    y = d.call(y)
    var b = List.filled(x.count+1, 0)
    var c = 0
    for (i in 1..x.count) {
        var s = d.call(x[x.count-i].bytes[0]) * y + c
        c = (s/10).floor
        b[b.count-i] = (s%10) + 48
    }
    if (c == 0) return b2s.call(b[1..-1])
    b[0] = c + 48
    return b2s.call(b)
}

// multiply two numbers as strings
var mul = Fn.new { |x, y|
    var result = mulDigit.call(x, y[y.count-1].bytes[0])
    var zeros = ""
    var i = 2
    while (i <= y.count) {
        zeros = zeros + "0"
        result = add.call(result, mulDigit.call(x, y[y.count-i].bytes[0]) + zeros)
        i = i + 1
    }
    result = result.trimStart("0")
    if (result == "") result = "0"
    return result
}

var n = "18446744073709551616"
Fmt.print("$,s", mul.call(n, n))
