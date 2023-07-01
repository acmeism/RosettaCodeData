import "/dynamic" for Enum

var RangeType = Enum.create("RangeType", ["CLOSED", "BOTH_OPEN", "LEFT_OPEN", "RIGHT_OPEN"])

class RealSet {
    construct new(start, end, pred) {
        _low  = start
        _high = end
        _pred = (pred == RangeType.CLOSED)     ? Fn.new { |d| d >= _low && d <= _high } :
                (pred == RangeType.BOTH_OPEN)  ? Fn.new { |d| d >  _low && d <  _high } :
                (pred == RangeType.LEFT_OPEN)  ? Fn.new { |d| d >  _low && d <= _high } :
                (pred == RangeType.RIGHT_OPEN) ? Fn.new { |d| d >= _low && d <  _high } : pred
    }

    low  { _low  }
    high { _high }
    pred { _pred }

    contains(d) { _pred.call(d) }

    union(other) {
        if (!other.type == RealSet) Fiber.abort("Argument must be a RealSet")
        var low2 = _low.min(other.low)
        var high2 = _high.max(other.high)
        return RealSet.new(low2, high2) { |d| _pred.call(d) || other.pred.call(d) }
    }

    intersect(other) {
        if (!other.type == RealSet) Fiber.abort("Argument must be a RealSet")
        var low2 = _low.max(other.low)
        var high2 = _high.min(other.high)
        return RealSet.new(low2, high2) { |d| _pred.call(d) && other.pred.call(d) }
    }

    subtract(other) {
        if (!other.type == RealSet) Fiber.abort("Argument must be a RealSet")
        return RealSet.new(_low, _high) { |d| _pred.call(d) && !other.pred.call(d) }
    }

    length {
        if (_low.isInfinity || _high.isInfinity) return -1  // error value
        if (_high <= _low) return 0
        var p = _low
        var count = 0
        var interval = 0.00001
        while (true) {
            if (_pred.call(p)) count = count + 1
            p = p + interval
            if (p >= _high) break
        }
        return count * interval
    }

    isEmpty { (_high == _low) ? !_pred.call(_low) : length == 0 }
}

var a = RealSet.new(0, 1, RangeType.LEFT_OPEN)
var b = RealSet.new(0, 2, RangeType.RIGHT_OPEN)
var c = RealSet.new(1, 2, RangeType.LEFT_OPEN)
var d = RealSet.new(0, 3, RangeType.RIGHT_OPEN)
var e = RealSet.new(0, 1, RangeType.BOTH_OPEN)
var f = RealSet.new(0, 1, RangeType.CLOSED)
var g = RealSet.new(0, 0, RangeType.CLOSED)

for (i in 0..2) {
    System.print("(0, 1] ∪ [0, 2) contains %(i) is %(a.union(b).contains(i))")
    System.print("[0, 2) ∩ (1, 2] contains %(i) is %(b.intersect(c).contains(i))")
    System.print("[0, 3) − (0, 1) contains %(i) is %(d.subtract(e).contains(i))")
    System.print("[0, 3) − [0, 1] contains %(i) is %(d.subtract(f).contains(i))\n")
}

System.print("[0, 0] is empty is %(g.isEmpty)\n")

var aa = RealSet.new(0, 10) { |x| (0 < x && x < 10) && ((Num.pi * x * x).sin.abs > 0.5) }
var bb = RealSet.new(0, 10) { |x| (0 < x && x < 10) && ((Num.pi * x).sin.abs > 0.5) }
var cc = aa.subtract(bb)
System.print("Approx length of A - B is %(cc.length)")
