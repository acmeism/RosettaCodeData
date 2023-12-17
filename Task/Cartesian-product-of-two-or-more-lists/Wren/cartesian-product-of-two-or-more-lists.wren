import "./seq" for Lst

var prod2 = Fn.new { |l1, l2|
    var res = []
    for (e1 in l1) {
        for (e2 in l2) res.add([e1, e2])
    }
    return res
}

var prodN = Fn.new { |ll|
    if (ll.count < 2) Fiber.abort("There must be at least two lists.")
    var p2 = prod2.call(ll[0], ll[1])
    return ll.skip(2).reduce(p2) { |acc, l| prod2.call(acc, l) }.map { |l| Lst.flatten(l) }.toList
}

var printProdN = Fn.new { |ll|
    System.print("%(ll.join(" x ")) = ")
    System.write("[\n    ")
    System.print(prodN.call(ll).join("\n    "))
    System.print("]\n")
}

System.print("[1, 2] x [3, 4] = %(prodN.call([ [1, 2], [3, 4] ]))")
System.print("[3, 4] x [1, 2] = %(prodN.call([ [3, 4], [1, 2] ]))")
System.print("[1, 2] x []     = %(prodN.call([ [1, 2], [] ]))")
System.print("[]     x [1, 2] = %(prodN.call([ [], [1, 2] ]))")
System.print("[1, a] x [2, b] = %(prodN.call([ [1, "a"], [2, "b"] ]))")
System.print()
printProdN.call([ [1776, 1789], [7, 12], [4, 14, 23], [0, 1] ])
printProdN.call([ [1, 2, 3], [30], [500, 100] ])
printProdN.call([ [1, 2, 3], [], [500, 100] ])
printProdN.call([ [1, 2, 3], [30], ["a", "b"] ])
