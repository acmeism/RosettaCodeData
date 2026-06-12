import "./fmt" for Fmt

/* "structured" adaptive version, translated from Racket */
var quadSimpsonMem = Fn.new { |f, a, fa, b, fb|
    // Evaluates Simpson's Rule, also returning m and f.call(m) to reuse.
    var m = (a + b) / 2
    var fm = f.call(m)
    var simp = (b - a).abs / 6 * (fa + 4*fm + fb)
    return [m, fm, simp]
}

var quadAsrRec // recursive
quadAsrRec = Fn.new { |f, a, fa, b, fb, eps, whole, m, fm|
    // Efficient recursive implementation of adaptive Simpson's rule.
    // Function values at the start, middle, end of the intervals are retained.
    var r1 = quadSimpsonMem.call(f, a, fa, m, fm)
    var r2 = quadSimpsonMem.call(f, m, fm, b, fb)
    var lm    = r1[0]
    var flm   = r1[1]
    var left  = r1[2]
    var rm    = r2[0]
    var frm   = r2[1]
    var right = r2[2]
    var delta = left + right - whole
    if (delta.abs < eps * 15) return left + right + delta/15
    return quadAsrRec.call(f, a, fa, m, fm, eps/2, left, lm, flm) +
           quadAsrRec.call(f, m, fm, b, fb, eps/2, right, rm, frm)
}

var quadAsr = Fn.new { |f, a, b, eps|
    // Integrate f from a to b using ASR with max error of eps.
    var fa = f.call(a)
    var fb = f.call(b)
    var r = quadSimpsonMem.call(f, a, fa, b, fb)
    var m     = r[0]
    var fm    = r[1]
    var whole = r[2]
    return quadAsrRec.call(f, a, fa, b, fb, eps, whole, m, fm)
}

var a = 0
var b = 1
var sinx = quadAsr.call(Fn.new { |x| x.sin }, a, b, 1e-09)
Fmt.print("Simpson's integration of sine from $d to $d = $f", a, b, sinx)
