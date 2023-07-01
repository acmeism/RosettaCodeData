var a = Fn.new { |bool|
    System.print("  a called")
    return bool
}

var b = Fn.new { |bool|
    System.print("  b called")
    return bool
}

var bools = [ [true, true], [true, false], [false, true], [false, false] ]
for (bool in bools) {
    System.print("a = %(bool[0]), b = %(bool[1]), op = && :")
    a.call(bool[0]) && b.call(bool[1])
    System.print()
}

for (bool in bools) {
    System.print("a = %(bool[0]), b = %(bool[1]), op = || :")
    a.call(bool[0]) || b.call(bool[1])
    System.print()
}
