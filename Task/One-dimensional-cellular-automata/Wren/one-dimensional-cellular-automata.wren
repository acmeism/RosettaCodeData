var trans = "___#_##_"

var v = Fn.new { |cell, i| (cell[i] != "_") ? 1 : 0 }

var evolve = Fn.new { |cell, backup|
    var len = cell.count - 2
    var diff = 0
    for (i in 1...len) {
        /* use left, self, right as binary number bits for table index */
        backup[i] = trans[v.call(cell, i - 1) * 4 + v.call(cell, i) * 2 + v.call(cell, i + 1)]
        diff = diff + ((backup[i] != cell[i]) ? 1 : 0)
    }
    cell.clear()
    cell.addAll(backup)
    return diff != 0
}

var c = "_###_##_#_#_#_#__#__".toList
var b = "____________________".toList
while(true) {
    System.print(c[1..-1].join())
    if (!evolve.call(c,b)) break
}
