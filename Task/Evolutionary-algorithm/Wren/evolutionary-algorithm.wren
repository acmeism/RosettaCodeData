import "random" for Random

var target = "METHINKS IT IS LIKE A WEASEL"
var set = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
var rand = Random.new()

// fitness:  0 is perfect fit.  greater numbers indicate worse fit.
var fitness = Fn.new { |a| (0...target.count).count { |i| a[i] != target[i] } }

// set m to mutation of p, with each character of p mutated with probability r
var mutate = Fn.new { |p, m, r|
    var i = 0
    for (ch in p) {
        if (rand.float(1) < r) {
            m[i] = set[rand.int(set.count)]
        } else {
            m[i] = ch
        }
        i = i + 1
    }
}

var parent = List.filled(target.count, "")
(0...parent.count).each { |i| parent[i] = set[rand.int(set.count)] }
var c = 20 // number of times to copy and mutate parent
var copies = List.filled(c, null)
for (i in 0...c) copies[i] = List.filled(parent.count, 0)
System.print(parent.join())
var best = fitness.call(parent)
while (best > 0) {
    for (cp in copies) mutate.call(parent, cp, 0.05)
    for (cp in copies) {
        var fm = fitness.call(cp)
        if (fm < best) {
            best = fm
            parent = cp.toList
            System.print(parent.join())
        }
    }
}
