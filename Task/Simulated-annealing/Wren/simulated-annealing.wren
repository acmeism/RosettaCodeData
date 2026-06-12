import "random" for Random
import "./math" for Math
import "./fmt" for Fmt

// distances
var calcDists = Fn.new {
    var dists = List.filled(10000, 0)
    for (i in 0..9999) {
        var ab = (i/100).floor
        var cd = i % 100
        var a  = (ab/10).floor
        var b  = ab % 10
        var c  = (cd/10).floor
        var d  = cd % 10
        dists[i] = Math.hypot(a-c, b-d)
    }
    return dists
}

var dists = calcDists.call()
var dirs = [1, -1, 10, -10, 9, 11, -11, -9] // all 8 neighbors
var rand = Random.new()

// index into lookup table of Nums
var dist = Fn.new { |ci, cj| dists[cj*100 + ci] }

// energy at s, to be minimized
var Es = Fn.new { |path|
    var d = 0
    for (i in 0...path.count-1) d = d + dist.call(path[i], path[i+1])
    return d
}

// temperature function, decreases to 0
var T = Fn.new { |k, kmax, kT| (1 - k / kmax) * kT }

// variation of E, from state s to state s_next
var dE = Fn.new { |s, u, v|
    var su = s[u]
    var sv = s[v]
    // old
    var a = dist.call(s[u-1], su)
    var b = dist.call(s[u+1], su)
    var c = dist.call(s[v-1], sv)
    var d = dist.call(s[v+1], sv)
    // new
    var na = dist.call(s[u-1], sv)
    var nb = dist.call(s[u+1], sv)
    var nc = dist.call(s[v-1], su)
    var nd = dist.call(s[v+1], su)
    if (v == u+1) return (na + nd) - (a + d)
    if (u == v+1) return (nc + nb) - (c + b)
    return (na + nb + nc + nd) - (a + b + c + d)
}

// probability to move from s to s_next
var P = Fn.new { |deltaE, k, kmax, kT| (-deltaE / T.call(k, kmax, kT)).exp }

// Simulated annealing
var sa = Fn.new { |kmax, kT|
    var temp = List.filled(99, 0)
    for (i in 0..98) temp[i] = i + 1
    rand.shuffle(temp)
    var s = List.filled(101, 0)
    for (i in 0..98) s[i+1] = temp[i]     // random path from 0 to 0
    System.print("kT = %(kT)")
    System.print("E(s0) %(Es.call(s))\n") // random starter
    var Emin = Es.call(s)                 // E0
    for (k in 0..kmax) {
        if (k % (kmax/10).floor == 0) {
            Fmt.print("k:$10d   T: $8.4f   Es: $8.4f", k, T.call(k, kmax, kT), Es.call(s))
        }
        var u = rand.int(1, 100)          // city index 1 to 99
        var cv = s[u] + dirs[rand.int(8)] // city number
        if (cv <= 0 || cv >= 100) {       // bogus city
            continue
        }
        if (dist.call(s[u], cv) > 5) {    // check true neighbor (eg 0 9)
            continue
        }
        var v = s[cv]                     // city index
        var deltae = dE.call(s, u, v)
        if (deltae < 0 ||                 // always move if negative
            P.call(deltae, k, kmax, kT) >= rand.float()) {
            s.swap(u, v)
            Emin = Emin + deltae
        }
    }
    System.print("\nE(s_final) %(Emin)")
    System.print("Path:")
    // output final state
    for (i in 0...s.count) {
        if (i > 0 && i % 10 == 0) System.print()
        Fmt.write("$4d", s[i])
    }
    System.print()
}

sa.call(1e6, 1)
