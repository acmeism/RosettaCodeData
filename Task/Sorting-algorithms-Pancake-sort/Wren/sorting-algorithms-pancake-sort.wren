import "/sort" for Find

class Pancake {
    construct new(a) {
        _a = a.toList
    }

    flip(r) {
        for (l in 0...r) {
            _a.swap(r, l)
            r = r - 1
        }
    }

    sort() {
        for (uns in _a.count-1..1) {
            var h = Find.highest(_a[0..uns])
            var lx = h[2][0]
            flip(lx)
            flip(uns)
        }
    }

    toString { _a.toString }
}

var p = Pancake.new([31, 41, 59, 26, 53, 58, 97, 93, 23, 84])
System.print("unsorted: %(p)")
p.sort()
System.print("sorted  : %(p)")
