import "/sort" for Sort

var fourFaceCombs = Fn.new {
    var res = []
    var found = List.filled(256, false)
    for (i in 1..4) {
        for (j in 1..4) {
            for (k in 1..4) {
                for (l in 1..4) {
                    var c = [i, j, k, l]
                    Sort.insertion(c)
                    var key = 64*(c[0]-1) + 16*(c[1]-1) + 4*(c[2]-1) + (c[3]-1)
                    if (!found[key]) {
                        found[key] = true
                        res.add(c)
                    }
                }
            }
        }
    }
    return res
}

var cmp = Fn.new { |x, y|
    var xw = 0
    var yw = 0
    for (i in 0..3) {
        for (j in 0..3) {
            if (x[i] > y[j]) {
                xw = xw + 1
            } else if (y[j] > x[i]) {
                yw = yw + 1
            }
        }
    }
    return (xw - yw).sign
}

var findIntransitive3 = Fn.new { |cs|
    var c = cs.count
    var res = []
    for (i in 0...c) {
        for (j in 0...c) {
            for (k in 0...c) {
                var first = cmp.call(cs[i], cs[j])
                if (first == -1) {
                    var second = cmp.call(cs[j], cs[k])
                    if (second == -1) {
                        var third  = cmp.call(cs[i], cs[k])
                        if (third == 1) res.add([cs[i], cs[j], cs[k]])
                    }
                }
            }
        }
    }
    return res
}

var findIntransitive4 = Fn.new { |cs|
    var c = cs.count
    var res = []
    for (i in 0...c) {
        for (j in 0...c) {
            for (k in 0...c) {
                for (l in 0...c) {
                    var first  = cmp.call(cs[i], cs[j])
                    if (first == -1) {
                        var second = cmp.call(cs[j], cs[k])
                        if (second == -1) {
                            var third  = cmp.call(cs[k], cs[l])
                            if (third == -1) {
                                var fourth = cmp.call(cs[i], cs[l])
                                if (fourth == 1) res.add([cs[i], cs[j], cs[k], cs[l]])
                            }
                        }
                    }
                }
            }
        }
    }
    return res
}

var combs = fourFaceCombs.call()
System.print("Number of eligible 4-faced dice: %(combs.count)")
var it = findIntransitive3.call(combs)
System.print("\n%(it.count) ordered lists of 3 non-transitive dice found, namely:")
System.print(it.join("\n"))
it = findIntransitive4.call(combs)
System.print("\n%(it.count) ordered lists of 4 non-transitive dice found, namely:")
System.print(it.join("\n"))
