var f = Fn.new { |a, b|
    System.print("a      = %(a)")
    System.print("b      = %(b)")
    System.print("!a     = %(!a)")
    System.print("a && b = %(a && b)")
    System.print("a || b = %(a || b)")
    System.print()
}

var tests = [ [true, true], [true, false], [false, true], [false, false] ]
for (test in tests) f.call(test[0], test[1])
