import "./assert" for Assert

var SturmianWordRat = Fn.new { |m, n|
    if (m > n) return SturmianWordRat.call(n, m).reduce("") { |acc, c|
        return acc + (c == "0" ? "1" : "0")
    }
    var sturmian = ""
    var k = 1
    while (k * m % n != 0) {
        var currFloor = (k * m / n).floor
        var prevFloor = ((k - 1) * m / n).floor
        sturmian = sturmian + (prevFloor == currFloor ? "0" : "10")
        k  = k + 1
    }
    return sturmian
}

var SturmianWordQuad = Fn.new { |a, b, m, n, k|
    var p = [0, 1]
    var q = [1, 0]
    var rem = (a.sqrt * b + m) / n
    for (i in 1..k) {
        var whole = rem.truncate
        var frac  = rem.fraction
        var pn = whole * p[-1] + p[-2]
        var qn = whole * q[-1] + q[-2]
        p.add(pn)
        q.add(qn)
        rem = 1 / frac
    }
    return SturmianWordRat.call(p[-1], q[-1])
}

var fibWord = Fn.new { |n|
    var sn1 = "0"
    var sn  = "01"
    for (i in 2..n) {
        var tmp = sn
        sn = sn + sn1
        sn1 = tmp
    }
    return sn
}

var fib = fibWord.call(10)
var sturmian = SturmianWordRat.call(13, 21)
Assert.equal(fib[0...sturmian.count], sturmian)
System.print("%(sturmian) from rational number 13/21")
var sturmian2 = SturmianWordQuad.call(5, 1, -1, 2, 8)
Assert.equal(sturmian, sturmian2)
System.print("%(sturmian2) from quadratic number (√5 - 1)/2 (k = 8)")
