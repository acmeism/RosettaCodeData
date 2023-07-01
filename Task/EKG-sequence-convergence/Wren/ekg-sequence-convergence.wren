import "/sort" for Sort
import "/math" for Int
import "/fmt" for Fmt

var areSame = Fn.new { |s, t|
    var le = s.count
    if (le != t.count) return false
    Sort.quick(s)
    Sort.quick(t)
    for (i in 0...le) if (s[i] != t[i]) return false
    return true
}

var limit = 100
var starts = [2, 5, 7, 9, 10]
var ekg = List.filled(5, null)
for (i in 0..4) ekg[i] = List.filled(limit, 0)
var s = 0
for (start in starts) {
    ekg[s][0] = 1
    ekg[s][1] = start
    for (n in 2...limit) {
        var i = 2
        while (true) {
            // a potential sequence member cannot already have been used
            // and must have a factor in common with previous member
            if (!ekg[s].take(n).contains(i) && Int.gcd(ekg[s][n-1], i) > 1) {
                ekg[s][n] = i
                break
            }
            i = i + 1
        }
    }
    Fmt.print("EKG($2d): $2d", start, ekg[s].take(30).toList)
    s = s + 1
}

// now compare EKG5 and EKG7 for convergence
for (i in 2...limit) {
    if (ekg[1][i] == ekg[2][i] && areSame.call(ekg[1][0...i], ekg[2][0...i])) {
        System.print("\nEKG(5) and EKG(7) converge at term %(i+1).")
        return
    }
}
System.print("\nEKG5(5) and EKG(7) do not converge within %(limit) terms.")
