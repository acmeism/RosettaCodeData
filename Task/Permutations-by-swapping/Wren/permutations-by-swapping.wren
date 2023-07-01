var johnsonTrotter = Fn.new { |n|
    var p = List.filled(n, 0)  // permutation
    var q = List.filled(n, 0)  // inverse permutation
    for (i in 0...n) p[i] = q[i] = i
    var d = List.filled(n, -1) // direction = 1 or -1
    var sign = 1
    var perms = []
    var signs = []

    var permute // recursive closure
    permute = Fn.new { |k|
        if (k >= n) {
            perms.add(p.toList)
            signs.add(sign)
            sign = sign * -1
            return
        }
        permute.call(k + 1)
        for (i in 0...k) {
            var z = p[q[k] + d[k]]
            p[q[k]] = z
            p[q[k] + d[k]] = k
            q[z] = q[k]
            q[k] = q[k] + d[k]
            permute.call(k + 1)
        }
        d[k] = d[k] * -1
    }
    permute.call(0)
    return [perms, signs]
}

var printPermsAndSigns = Fn.new { |perms, signs|
    var i = 0
    for (perm in perms) {
        System.print("%(perm) -> sign = %(signs[i])")
        i = i + 1
    }
}

var res = johnsonTrotter.call(3)
var perms = res[0]
var signs = res[1]
printPermsAndSigns.call(perms, signs)
System.print()
res = johnsonTrotter.call(4)
perms = res[0]
signs = res[1]
printPermsAndSigns.call(perms, signs)
