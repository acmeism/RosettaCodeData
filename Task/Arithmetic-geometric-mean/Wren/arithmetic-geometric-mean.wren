var eps = 1e-14

var agm = Fn.new { |a, g|
    while ((a-g).abs > a.abs * eps) {
        var t = a
        a = (a+g)/2
        g = (t*g).sqrt
    }
    return a
}

System.print(agm.call(1, 1/2.sqrt))
