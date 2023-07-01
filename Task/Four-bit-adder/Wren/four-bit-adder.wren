var xor = Fn.new { |a, b| a&(~b) | b&(~a) }

var ha = Fn.new { |a, b| [xor.call(a, b), a & b] }

var fa = Fn.new { |a, b, c0|
    var res = ha.call(a, c0)
    var sa = res[0]
    var ca = res[1]
    res = ha.call(sa, b)
    return [res[0], ca | res[1]]
}

var add4 = Fn.new { |a3, a2, a1, a0, b3, b2, b1, b0|
    var res = fa.call(a0, b0, 0)
    var s0 = res[0]
    var c0 = res[1]
    res = fa.call(a1, b1, c0)
    var s1 = res[0]
    var c1 = res[1]
    res = fa.call(a2, b2, c1)
    var s2 = res[0]
    var c2 = res[1]
    res = fa.call(a3, b3, c2)
    return [res[1], res[0], s2, s1, s0]
}

System.print(add4.call(1, 0, 1, 0, 1, 0, 0, 1))
