import "./fmt" for Conv

var SIZE  = 32
var LINES = SIZE / 2
var RULE  = 90

var ruleTest = Fn.new { |x| (RULE & (1 << (7 & x))) != 0 }

var bshl = Fn.new { |b, bitCount| Conv.btoi(b) << bitCount }

var evolve = Fn.new { |s|
    var t = List.filled(SIZE, false)
    t[SIZE-1] = ruleTest.call(bshl.call(s[0], 2) | bshl.call(s[SIZE-1], 1) | Conv.btoi(s[SIZE-2]))
    t[0] = ruleTest.call(bshl.call(s[1], 2) | bshl.call(s[0], 1) | Conv.btoi(s[SIZE-1]))
    for (i in 1...SIZE - 1) {
        t[i] = ruleTest.call(bshl.call(s[i+1], 2) | bshl.call(s[i], 1) | Conv.btoi(s[i-1]))
    }
    for (i in 0...SIZE) s[i] = t[i]
}

var show = Fn.new { |s|
    for (i in SIZE - 1..0) System.write(s[i] ? "*" : " ")
    System.print()
}

var state = List.filled(SIZE, false)
state[LINES] = true
System.print("Rule %(RULE):")
for (i in 0...LINES) {
    show.call(state)
    evolve.call(state)
}
