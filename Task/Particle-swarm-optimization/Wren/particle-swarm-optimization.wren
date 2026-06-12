import "random" for Random
import "./dynamic" for Tuple

var Parameters = Tuple.create("Parameters", ["omega", "phip", "phig"])

var fields = [
    "iter", "gbpos", "gbval", "min", "max", "parameters",
    "pos", "vel", "bpos", "bval", "nParticles", "nDims"
]

var State = Tuple.create("State", fields)

var report = Fn.new { |state, testfunc|
    System.print("Test Function         : %(testfunc)")
    System.print("Iterations            : %(state.iter)")
    System.print("Global Best Position  : %(state.gbpos)")
    System.print("Global Best Value     : %(state.gbval)")
}

var psoInit = Fn.new { |min, max, parameters, nParticles|
    var nDims = min.count
    var pos   = List.filled(nParticles, null)
    var vel   = List.filled(nParticles, null)
    var bpos  = List.filled(nParticles, null)
    var bval  = List.filled(nParticles, 1/0)
    for (i in 0...nParticles) {
        pos[i]  = min.toList
        vel[i]  = List.filled(nDims, 0)
        bpos[i] = min.toList
    }
    var iter  = 0
    var gbpos = List.filled(nDims, 1/0 )
    var gbval = 1/0
    return State.new(iter, gbpos, gbval, min, max, parameters,
                     pos, vel, bpos, bval, nParticles, nDims)
}

var r = Random.new()

var pso = Fn.new { |fn, y|
    var p = y.parameters
    var v = List.filled(y.nParticles, 0)
    var bpos  = List.filled(y.nParticles, null)
    for (i in 0...y.nParticles) bpos[i] = y.min.toList
    var bval  = List.filled(y.nParticles, 0)
    var gbpos = List.filled(y.nDims, 0)
    var gbval = 1/0
    for (j in 0...y.nParticles) {
        // evaluate
        v[j] = fn.call(y.pos[j])
        // update
        if (v[j] < y.bval[j]) {
            bpos[j] = y.pos[j]
            bval[j] = v[j]
        } else {
            bpos[j] = y.bpos[j]
            bval[j] = y.bval[j]
        }
        if (bval[j] < gbval) {
            gbval = bval[j]
            gbpos = bpos[j]
        }
    }
    var rg = r.float()
    var pos = List.filled(y.nParticles, null)
    var vel = List.filled(y.nParticles, null)
    for (i in 0...y.nParticles) {
        pos[i] = List.filled(y.nDims, 0)
        vel[i] = List.filled(y.nDims, 0)
    }
    for (j in 0...y.nParticles) {
        // migrate
        var rp = r.float()
        var ok = true
        for (k in 0...y.nDims) {
            vel[j][k] = p.omega * y.vel[j][k] +
                        p.phip * rp * (bpos[j][k] - y.pos[j][k]) +
                        p.phig * rg * (gbpos[k] - y.pos[j][k])
            pos[j][k] = y.pos[j][k] + vel[j][k]
            ok = ok && y.min[k] < pos[j][k] && y.max[k] > pos[j][k]
        }
        if (!ok) {
            for (k in 0...y.nDims) {
                pos[j][k]= y.min[k] + (y.max[k] - y.min[k]) * r.float()
            }
        }
    }
    var iter = 1 + y.iter
    return State.new(
        iter, gbpos, gbval, y.min, y.max, y.parameters,
        pos, vel, bpos, bval, y.nParticles, y.nDims
    )
}

var iterate = Fn.new { |fn, n, y|
    var r = y
    var old = y
    if (n == 2147483647) {
        while (true) {
            r = pso.call(fn, r)
            if (r == old) break
            old = r
        }
    } else {
        for (i in 1..n) r = pso.call(fn, r)
    }
    return r
}

var mccormick = Fn.new { |x|
    var a = x[0]
    var b = x[1]
    return (a + b).sin + (a - b) * (a - b) + 1 + 2.5 * b - 1.5 * a
}

var michalewicz = Fn.new { |x|
    var m = 10
    var d = x.count
    var sum = 0
    for (i in 1..d) {
        var j = x[i - 1]
        var k = (i * j * j / Num.pi).sin
        sum = sum + j.sin * k.pow(2 * m)
    }
    return -sum
}

var state = psoInit.call([-1.5, -3], [4, 4], Parameters.new(0, 0.6, 0.3), 100)
state = iterate.call(mccormick, 40, state)
report.call(state, "McCormick")
System.print("f(-0.54719, -1.54719) : %(mccormick.call([-0.54719, -1.54719]))")
System.print()
state = psoInit.call([0, 0], [Num.pi, Num.pi], Parameters.new(0.3, 0.3, 0.3), 1000)
state = iterate.call(michalewicz, 30, state)
report.call(state, "Michalewicz (2D)")
System.print("f(2.20, 1.57)         : %(michalewicz.call([2.2, 1.57]))")
