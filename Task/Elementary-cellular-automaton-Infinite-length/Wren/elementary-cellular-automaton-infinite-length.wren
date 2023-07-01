import "/fmt" for Fmt

var addNoCells = Fn.new { |s|
    var l = (s[0] == "*") ? "." : "*"
    var r = (s[-1] == "*") ? "." : "*"
    for (i in 0..1) {
       s.insert(0, l)
       s.add(r)
    }
}

var step = Fn.new { |cells, rule|
    var newCells = []
    for (i in 0...cells.count - 2) {
        var bin = 0
        var b = 2
        for (n in i...i + 3) {
            bin = bin + (((cells[n] == "*") ? 1 : 0) << b)
            b = b >> 1
        }
        var a = ((rule & (1 << bin)) != 0) ? "*" : "."
        newCells.add(a)
    }
    return newCells
}

var evolve = Fn.new { |l, rule|
    System.print(" Rule #%(rule):")
    var cells = ["*"]
    for (x in 0...l) {
        addNoCells.call(cells)
        var width = 40 + (cells.count >> 1)
        Fmt.print("$*s", width, cells.join())
        cells = step.call(cells, rule)
    }
}

evolve.call(35, 90)
System.print()
