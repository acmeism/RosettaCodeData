var quibbling = Fn.new { |w|
    var c = w.count
    if (c == 0) return "{}"
    if (c == 1) return "{%(w[0])}"
    if (c == 2) return "{%(w[0]) and %(w[1])}"
    return "{%(w[0..-2].join(", ")) and %(w[-1])}"
}

var words = [ [], ["ABC"], ["ABC", "DEF"], ["ABC", "DEF", "G", "H"] ]
for (w in words) System.print(quibbling.call(w))
