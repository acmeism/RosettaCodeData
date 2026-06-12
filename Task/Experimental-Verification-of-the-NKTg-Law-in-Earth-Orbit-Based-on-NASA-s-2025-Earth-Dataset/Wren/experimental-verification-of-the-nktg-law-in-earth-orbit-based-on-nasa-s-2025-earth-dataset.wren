import "./dynamic" for Tuple
import "./fmt" for Fmt

var OrbitalData = Tuple.create("OrbitalData", ["date", "x", "v", "m"])

var ResultRow   = Tuple.create("ResultRow", ["date", "p", "nktg1", "nktg2", "vSim", "vNasa", "error"])

// Displays a formatted ResultRow
var display = Fn.new { |rr|
    var f = "$-12s $14s $14s $14s $12s $12s $10.4f\%"
    Fmt.lprint(f, [rr.date, rr.p, rr.nktg1, rr.nktg2, rr.vSim, rr.vNasa, rr.error])
}

var DM_DT = -1.8  // kg/s

var momentum = Fn.new { |m, v| m * v }
var nktg1    = Fn.new { |x, p| x * p }
var nktg2    = Fn.new { |p| DM_DT * p }

var relativeError = Fn.new { |sim, nasa| (sim - nasa) / nasa * 100 }

// Zero fills the significand of a numeric string expressed
// in scientific notation to 'p' decimal places.
var ezfill = Fn.new { |e, p|
    var s = e.split("e")
    var n = Num.fromString(s[0])
    return Fmt.f(0, n, p) + "e" + s[1]
}

// Simulated NKTg 2025 dataset
var sim2025 = [
    OrbitalData.new("01/01/2025", 1.471012e11, 3.0276e4, 5.97219e24),
    OrbitalData.new("04/01/2025", 1.494953e11, 2.9791e4, 5.97218999999998e24),
    OrbitalData.new("07/01/2025", 1.520965e11, 2.9282e4, 5.97218999999997e24),
    OrbitalData.new("10/01/2025", 1.496328e11, 2.9764e4, 5.97218999999995e24),
    OrbitalData.new("12/31/2025", 1.471025e11, 3.0276e4, 5.97218999999994e24)
]

// NASA observed velocities
var nasa2025 = [
    ["01/01/2025", 3.0287e4],
    ["04/01/2025", 2.9791e4],
    ["07/01/2025", 2.9291e4],
    ["10/01/2025", 2.9778e4],
    ["12/31/2025", 3.0286e4]
]

System.print("\nExperimental Verification of NKTg Law (Earth 2025)\n")

var f = "$-12s $14s $14s $14s $12s $12s $10s"
Fmt.lprint(f, ["Date", "Momentum(p)", "NKTg1", "NKTg2", "v_sim", "v_NASA", "Error"])
System.print("-" * 95)

var i = 0
for (data in sim2025) {
    var p     = momentum.call(data.m, data.v)
    var n1    = nktg1.call(data.x, p)
    var n2    = nktg2.call(p)
    var vSim  = data.v
    var vNasa = nasa2025[i][1]
    var err   = relativeError.call(data.v, vNasa)

    p     = ezfill.call(Fmt.e(0, p, 3), 3)
    n1    = ezfill.call(Fmt.e(0, n1, 3), 3)
    n2    = ezfill.call(Fmt.e(0, n2, 3), 3)
    vNasa = ezfill.call(Fmt.e(0, vNasa, 3), 3)
    vSim  = ezfill.call(Fmt.e(0, vSim, 3), 3)

    var row = ResultRow.new(data.date, p, n1, n2, vSim, vNasa, err)
    display.call(row)
    i = i + 1
}
