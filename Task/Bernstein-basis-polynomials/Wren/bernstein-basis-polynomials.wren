import "./fmt" for Fmt
import "./math" for Math

var toBern2 = Fn.new { |a| [a[0], a[0] + a[1] / 2, a[0] + a[1] + a[2]] }

// uses de Casteljau's algorithm
var evalBern2 = Fn.new { |b, t|
    var s = 1 - t
    var b01 = s * b[0] + t * b[1]
    var b12 = s * b[1] + t * b[2]
    return s * b01 + t * b12
}

var toBern3 = Fn.new { |a|
    var b = List.filled(4, 0)
    b[0] = a[0]
    b[1] = a[0] + a[1] / 3
    b[2] = a[0] + a[1] * 2/3 + a[2] / 3
    b[3] = a[0] + a[1] + a[2] + a[3]
    return b
}

// uses de Casteljau's algorithm
var evalBern3 = Fn.new { |b, t|
    var s = 1 - t
    var b01  = s * b[0] + t * b[1]
    var b12  = s * b[1] + t * b[2]
    var b23  = s * b[2] + t * b[3]
    var b012 = s * b01  + t * b12
    var b123 = s * b12  + t * b23
    return s * b012 + t * b123
}

var bern2to3 = Fn.new { |q|
    var c = List.filled(4, 0)
    c[0] = q[0]
    c[1] = q[0] / 3   + q[1] * 2/3
    c[2] = q[1] * 2/3 + q[2] / 3
    c[3] = q[2]
    return c
}

var pm = [1, 0, 0]
var qm = [1, 2, 3]
var rm = [1, 2, 3, 4]
var x
var y
var m

System.print("Subprogram(1) examples:")
var pb2 = toBern2.call(pm)
var qb2 = toBern2.call(qm)
Fmt.print("mono $n --> bern $n", pm, pb2)
Fmt.print("mono $n --> bern $n", qm, qb2)

System.print("\nSubprogram(2) examples:")
x = 0.25
y = evalBern2.call(pb2, x)
m = Math.evalPoly(pm[-1..0], x)
Fmt.print("p($4.2f) = $j (mono $j)", x, y, m)
x = 7.5
y = evalBern2.call(pb2, x)
m = Math.evalPoly(pm[-1..0], x)
Fmt.print("p($4.2f) = $j (mono $j)", x, y, m)
x = 0.25
y = evalBern2.call(qb2, x)
m = Math.evalPoly(qm[-1..0], x)
Fmt.print("q($4.2f) = $j (mono $j)", x, y, m)
x = 7.5
y = evalBern2.call(qb2, x)
m = Math.evalPoly(qm[-1..0], x)
Fmt.print("q($4.2f) = $j (mono $j)", x, y, m)

System.print("\nSubprogram(3) examples:")
pm.add(0)
qm.add(0)
var pb3 = toBern3.call(pm)
var qb3 = toBern3.call(qm)
var rb3 = toBern3.call(rm)
Fmt.print("mono $n --> bern $n", pm, pb3)
Fmt.print("mono $n --> bern $n", qm, qb3)
Fmt.print("mono $n --> bern $n", rm, rb3)

System.print("\nSubprogram(4) examples:")
x = 0.25
y = evalBern3.call(pb3, x)
m = Math.evalPoly(pm[-1..0], x)
Fmt.print("p($4.2f) = $j (mono $j)", x, y, m)
x = 7.5
y = evalBern3.call(pb3, x)
m = Math.evalPoly(pm[-1..0], x)
Fmt.print("p($4.2f) = $j (mono $j)", x, y, m)
x = 0.25
y = evalBern3.call(qb3, x)
m = Math.evalPoly(qm[-1..0], x)
Fmt.print("q($4.2f) = $j (mono $j)", x, y, m)
x = 7.5
y = evalBern3.call(qb3, x)
m = Math.evalPoly(qm[-1..0], x)
Fmt.print("q($4.2f) = $j (mono $j)", x, y, m)
x = 0.25
y = evalBern3.call(rb3, x)
m = Math.evalPoly(rm[-1..0], x)
Fmt.print("r($4.2f) = $j (mono $j)", x, y, m)
x = 7.5
y = evalBern3.call(rb3, x)
m = Math.evalPoly(rm[-1..0], x)
Fmt.print("r($4.2f) = $j (mono $j)", x, y, m)

System.print("\nSubprogram(5) examples:")
var pc = bern2to3.call(pb2)
var qc = bern2to3.call(qb2)
Fmt.print("mono $n --> bern $n", pb2, pc)
Fmt.print("mono $n --> bern $n", qb2, qc)
