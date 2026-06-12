import "./dynamic" for Struct
import "./fmt" for Fmt

var Save = Struct.create("Save", ["p", "i", "v"])

var N    = 32
var NMAX = 40000

var u     = List.filled(N, 0)  // upper bounds
var l     = List.filled(N, 0)  // lower bounds
var out   = List.filled(N, 0)
var sum   = List.filled(N, 0)
var tail  = List.filled(N, 0)
var cache = List.filled(NMAX + 1, 0)
var known = 2
var stack = 0
var undo  = List.filled(N * N, null)

for (i in 0..1) l[i] = u[i] = i + 1
for (i in 0...N*N) undo[i] = Save.new(null, 0, 0)
cache[2] = 1

var replace = Fn.new { |x, i, n|
    undo[stack].p = x
    undo[stack].i = i
    undo[stack].v = x[i]
    x[i] = n
    stack = stack + 1
}

var restore = Fn.new { |n|
    while (stack > n) {
        stack = stack - 1
        undo[stack].p[undo[stack].i] = undo[stack].v
    }
}

/* lower and upper bounds */
var lower = Fn.new { |n, up|
    if (n <= 2 || (n <= NMAX && cache[n] != 0)) {
        if (up.count > 0) up[0] = cache[n]
        return cache[n]
    }
    var i = -1
    var o =  0
    while (n != 0) {
        if ((n&1) != 0) o = o + 1
        n = n >> 1
        i = i + 1
    }
    if (up.count > 0) {
        i = i - 1
        up[0] = o + i
    }
    while (true) {
        i = i + 1
        o = o >> 1
        if (o == 0) break
    }
    o = 2
    while (o * o < n) {
        if (n%o != 0) {
            o = o + 1
            continue
        }
        var q = cache[o] + cache[(n/o).floor]
        if (q < up[0]) {
            up[0] = q
            if (q == i) break
        }
        o = o + 1
    }
    if (n > 2) {
        if (up[0] > cache[n-2] + 1) up[0] = cache[n-1] + 1
        if (up[0] > cache[n-2] + 1) up[0] = cache[n-2] + 1
    }
    return i
}

var insert = Fn.new { |x, pos|
    var save = stack
    if (l[pos] > x || u[pos] < x) return false
    if (l[pos] != x) {
        replace.call(l, pos, x)
        var i = pos - 1
        while (u[i]*2 < u[i+1]) {
            var t = l[i+1] + 1
            if (t * 2 > u[i]) {
                restore.call(save)
                return false
            }
            replace.call(l, i, t)
            i = i - 1
        }
        i = pos + 1
        while (l[i] <= l[i-1]) {
            var t = l[i-1] + 1
            if (t > u[i]) {
                restore.call(save)
                return false
            }
            replace.call(l, i, t)
            i = i + 1
        }
    }
    if (u[pos] == x) return true
    replace.call(u, pos, x)
    var i = pos - 1
    while (u[i] >= u[i+1]) {
        var t = u[i+1] - 1
        if (t < l[i]) {
            restore.call(save)
            return false
        }
        replace.call(u, i, t)
        i = i - 1
    }
    i = pos + 1
    while (u[i] > u[i-1]*2) {
        var t = u[i-1] * 2
        if (t < l[i]) {
            restore.call(save)
            return false
        }
        replace.call(u, i, t)
        i = i + 1
    }
    return true
}

var try  // forward declaration

var seqRecur = Fn.new { |le|
    var n = l[le]
    if (le < 2) return true
    var limit = n - 1
    if (out[le] == 1) limit = n - tail[sum[le]]
    if (limit > u[le-1]) limit = u[le-1]

    // Try to break n into p + q, and see if we can insert p, q into
    // list while satisfying bounds.
    var p = limit
    var q = n - p
    while (q <= p) {
        if (try.call(p, q, le)) return true
        q = q + 1
        p = p -1
    }
    return false
}

try = Fn.new { |p, q, le|
    var pl = cache[p]
    if (pl >= le) return false
    var ql = cache[q]
    if (ql >= le) return false
    while (pl < le && u[pl] < p) pl = pl + 1
    var pu = pl - 1
    while (pu < le-1 && u[pu+1] >= p) pu = pu + 1
    while (ql < le && u[ql] < q) ql = ql + 1
    var qu = ql - 1
    while (qu < le-1 && u[qu+1] >= q) qu = qu + 1
    if (p != q && pl <= ql) pl = ql + 1
    if (pl > pu || ql > qu || ql > pu) return false
    if (out[le] == 0) {
        pu = le - 1
        pl = pu
    }
    var ps = stack
    while (pu >= pl) {
        if (!insert.call(p, pu)) {
            pu = pu - 1
            continue
        }
        out[pu] = out[pu] + 1
        sum[pu] = sum[pu] + le
        if (p != q) {
            var qs = stack
            var j = qu
            if (j >= pu) j = pu - 1
            while (j >= ql) {
                if (!insert.call(q, j)) {
                    j = j - 1
                    continue
                }
                out[j] = out[j] + 1
                sum[j] = sum[j] + le
                tail[le] = q
                if (seqRecur.call(le - 1)) return true
                restore.call(qs)
                out[j] = out[j] - 1
                sum[j] = sum[j] - le
                j = j - 1
            }
        } else {
            out[pu] = out[pu] + 1
            sum[pu] = sum[pu] + le
            tail[le] = p
            if (seqRecur.call(le - 1)) return true
            out[pu] = out[pu] - 1
            sum[pu] = sum[pu] - le
        }
        out[pu] = out[pu] - 1
        sum[pu] = sum[pu] - le
        restore.call(ps)
        pu = pu - 1
    }
    return false
}

var seq  // forward declaration

var seqLen // recursive function
seqLen = Fn.new { |n|
    if (n <= known) return cache[n]
    // Need all lower n to compute sequence.
    while (known+1 < n) seqLen.call(known + 1)
    var ub = 0
    var pub = [ub]
    var lb = lower.call(n, pub)
    ub = pub[0]
    while (lb < ub && seq.call(n, lb, []) == 0) {
        lb = lb + 1
    }
    known = n
    if (n&1023 == 0) System.print("Cached %(known)")
    cache[n] = lb
    return lb
}

seq = Fn.new { |n, le, buf|
    if (le == 0) le = seqLen.call(n)
    stack = 0
    l[le] = u[le] = n
    for (i in 0..le) out[i] = sum[i] = 0
    var i = 2
    while (i < le) {
        l[i] = l[i-1] + 1
        u[i] = u[i-1] * 2
        i = i + 1
    }
    i = le - 1
    while (i > 2) {
        if (l[i]*2 < l[i+1]) {
            l[i] = ((1 + l[i+1]) / 2).floor
        }
        if (u[i] >= u[i+1]) {
            u[i] = u[i+1] - 1
        }
        i = i - 1
    }
    if (!seqRecur.call(le)) return 0
    if (buf.count > 0) {
        for (i in 0..le) buf[i] = u[i]
    }
    return le
}

var binLen = Fn.new { |n|
    var r = -1
    var o = -1
    while (n != 0) {
        if (n&1 != 0) o = o + 1
        n = n >> 1
        r = r + 1
    }
    return r + o
}

var mul = Fn.new { |m1, m2|
    var rows1 = m1.count
    var rows2 = m2.count
    var cols1 = m1[0].count
    var cols2 = m2[0].count
    if (cols1 != rows2) Fiber.abort("Matrices cannot be multiplied.")
    var result = List.filled(rows1, null)
    for (i in 0...rows1) {
        result[i] = List.filled(cols2, 0)
        for (j in 0...cols2) {
            for (k in 0...rows2) {
                result[i][j] = result[i][j] + m1[i][k] * m2[k][j]
            }
        }
    }
    return result
}

var pow = Fn.new { |m, n, printout|
    var e = List.filled(N, 0)
    var v = List.filled(N, null)
    for (i in 0...N) v[i] = List.filled(N, 0)
    var le = seq.call(n, 0, e)
    if (printout) {
        System.print("Addition chain:")
        for (i in 0..le) {
            var c = (i == le) ? "\n" : " "
            System.write("%(e[i])%(c)")
        }
    }
    v[0] = m
    v[1] = mul.call(m, m)
    var i = 2
    while (i <= le) {
        var j = i - 1
        while (j != 0) {
            for (k in j..0) {
                if (e[k]+e[j] < e[i]) break
                if (e[k]+e[j] > e[i]) continue
                v[i] = mul.call(v[j], v[k])
                j = 1
                break
            }
            j = j - 1
        }
        i = i + 1
    }
    return v[le]
}

var print = Fn.new { |m|
    for (v in m) Fmt.print("$9.6f", v)
    System.print()
}

var m = 27182
var n = 31415
System.print("Precompute chain lengths:")
seqLen.call(n)
var rh = (0.5).sqrt
var mx = [
    [rh,  0, rh,   0, 0, 0],
    [0,  rh,  0,  rh, 0, 0],
    [0,  rh,  0, -rh, 0, 0],
    [-rh, 0, rh,   0, 0, 0],
    [0,   0,  0,   0, 0, 1],
    [0,   0,  0,   0, 1, 0]
]
System.print("\nThe first 100 terms of A003313 are:")
for (i in 1..100) {
    Fmt.write("$d ", seqLen.call(i))
    if (i%10 == 0) System.print()
}
var exs = [m, n]
var mxs = List.filled(2, null)
var i = 0
for (ex in exs) {
    System.print("\nExponent: %(ex)")
    mxs[i] = pow.call(mx, ex, true)
    Fmt.print("A ^ $d:-\n", ex)
    print.call(mxs[i])
    System.print("Number of A/C multiplies: %(seqLen.call(ex))")
    System.print("  c.f. Binary multiplies: %(binLen.call(ex))")
    i = i + 1
}
Fmt.print("\nExponent: $d x $d = $d", m, n, m*n)
Fmt.print("A ^ $d = (A ^ $d) ^ $d:-\n", m*n, m, n)
var mx2 = pow.call(mxs[0], n, false)
print.call(mx2)
