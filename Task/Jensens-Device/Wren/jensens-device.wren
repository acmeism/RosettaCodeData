class Box {
    construct new(v) { _v = v }
    v { _v }
    v=(value) { _v = value }
}

var i = Box.new(0)  // any initial value will do here

var sum = Fn.new { |i, lo, hi, term|
    var temp = 0
    i.v = lo
    while (i.v <= hi) {
        temp = temp + term.call()
        i.v = i.v + 1
    }
    return temp
}

var s = sum.call(i, 1, 100, Fn.new { 1/i.v })
System.print(s)
