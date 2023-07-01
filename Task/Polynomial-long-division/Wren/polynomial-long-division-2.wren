class Polynom {
    construct new(factors) {
        _factors = factors.toList
    }

    factors { _factors.toList }

    /(divisor) {
        var curr = canonical().factors
        var right = divisor.canonical().factors
        var result = []
        var base = curr.count - right.count
        while (base >= 0) {
            var res = curr[-1] / right[-1]
            result.add(res)
            curr = curr[0...-1]
            for (i in 0...right.count-1) {
                curr[base + i] = curr[base + i] - res * right[i]
            }
            base = base - 1
        }
        var quot = Polynom.new(result[-1..0])
        var rem = Polynom.new(curr).canonical()
        return [quot, rem]
    }

    canonical() {
        if (_factors[-1] != 0) return this
        var newLen = factors.count
        while (newLen > 0) {
            if (_factors[newLen-1] != 0) return Polynom.new(_factors[0...newLen])
            newLen = newLen - 1
        }
        return Polynom.new(_factors[0..0])
    }

    toString { "Polynomial(%(_factors.join(", ")))" }
}

var num = Polynom.new([-42, 0, -12, 1])
var den = Polynom.new([-3, 1, 0, 0])
var res = num / den
var quot = res[0]
var rem = res[1]
System.print("%(num) / %(den) = %(quot) remainder %(rem)")
