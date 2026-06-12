import "./fmt" for Fmt
import "./sort" for Sort

var groups = {}

var areSame = Fn.new { |a, b|
    for (i in 0...a.count) {
        if (a[i] != b[i]) return false
    }
    return true
}

var breakdown = Fn.new { |count, places|
    System.print("\nFor the first %(count) shuffle groups, there are:")
    var cw = List.filled(9, 0)
    for (me in groups) {
        var wits = me.value
        cw[wits.count - 1] = cw[wits.count - 1] + 1
    }
    for (k in 8..0) {
        if (cw[k] > 0) {
            Fmt.print("$*d with $d witness$s", places, cw[k], k + 1, k > 0 ? "es" : "")
        }
    }
}

var showFirst = Fn.new { |kind, count, base, places|
    System.print("\nFirst shuffle group with %(kind) witnesses")
    System.print("index group")
    Fmt.print(" $d  [$d $s]", count, base, groups[base].join(" "))
    breakdown.call(count, places)
}

var i = 12
var p = 100
var hp = 50
var c = 0
var first20 = false
var wits4p  = false
var wits3   = false
while (true) {
    var digs = []
    var wits = []
    for (j in 2..9) {
        var m = i * j
        if (m >= p) break
        if (digs.count == 0) digs = Sort.insertion(i.toString.toList)
        var digs2 = Sort.insertion(m.toString.toList)
        if (areSame.call(digs, digs2)) wits.add(j)
    }
    if (wits.count > 0) {
        groups[i] = wits
        c = c + 1
        if (!first20 && c == 20) {
            System.print("First 20 shuffle groups:")
            System.print("index group")
            var sortedKeys = groups.keys.toList.sort()
            for (k in 1..20) {
                var key = sortedKeys[k - 1]
                Fmt.print(" $2d   [$5d $s]", k, key, groups[key].join(" "))
            }
            first20 = true
        }
        if (!wits4p && wits.count > 4) {
            showFirst.call("more than 4", c, i, 3)
            wits4p = true
        }
        if (!wits3 && wits.count == 3) {
            showFirst.call("exactly 3", c, i, 3)
            wits3 = true
            return
        }
    }
    i = i + 1
    if (i % 10 == 0) {
        if (i == hp) {
            i = p
            p = p * 10
            hp = hp * 10
        }
        i = i + 1
    }
}
