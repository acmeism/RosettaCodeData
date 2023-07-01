import "/dynamic" for Tuple
import "/seq" for Lst

var P = Tuple.create("P", ["x", "y", "sum", "prod"])

var intersect = Fn.new { |l1, l2|
    var l3 = (l1.count < l2.count) ? l1 : l2
    var l4 = (l3 == l1) ? l2 : l1
    var l5 = []
    for (e in l3) if (l4.contains(e)) l5.add(e)
    return l5
}

var candidates = []
for (x in 2..49) {
    for (y in x + 1..100 - x) {
        candidates.add(P.new(x, y, x + y, x * y))
    }
}

var sumGroups  = Lst.groups(candidates) { |c| c.sum }
var prodGroups = Lst.groups(candidates) { |c| c.prod }
var sumMap = {}
for (sumGroup in sumGroups) {
    sumMap[sumGroup[0]] = sumGroup[1].map { |l| l[0] }.toList
}
var prodMap = {}
for (prodGroup in prodGroups) {
    prodMap[prodGroup[0]] = prodGroup[1].map { |l| l[0] }.toList
}
var fact1 = candidates.where { |c| sumMap[c.sum].all { |c| prodMap[c.prod].count > 1 } }.toList
var fact2 = fact1.where { |c| intersect.call(prodMap[c.prod], fact1).count == 1 }.toList
var fact3 = fact2.where { |c| intersect.call(sumMap[c.sum], fact2).count == 1 }.toList
System.write("The only solution is : ")
for (p in fact3) System.print("x = %(p.x), y = %(p.y)")
