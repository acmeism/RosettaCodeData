var computeNKTg = Fn.new { |x, v, m, dmDt|
    var p = m * v
    var nktg1 = x * p
    var nktg2 = dmDt * p
    var nktg = (nktg1 * nktg1 + nktg2 * nktg2).sqrt

    System.print("--------------------------------------------")
    System.print("Position (x)         : %(x)")
    System.print("Velocity (v)         : %(v)")
    System.print("Mass (m)             : %(m)")
    System.print("Momentum (p = m * v) : %(p)")
    System.print("NKTg1 = x * p        : %(nktg1)")
    System.print("NKTg2 = dm_dt * p    : %(nktg2)")
    System.print("Total NKTg           : %(nktg)")
}

System.print("============================================")
System.print("NKTg Law - Neptune 2023 NASA Data")
System.print("============================================")

// 2023 NASA Data (Neptune)
var dmDt = -0.00002000

var data2023 = [
    [4498396440.0, 5.43, 1.02430000e26],
    [4503443661.0, 5.43, 1.02429980e26],
    [4553946490.0, 5.43, 1.02429960e26],
    [4503443661.0, 5.43, 1.02429940e26],
    [4498396440.0, 5.43, 1.02429920e26]
]

for (e in data2023) {
    var x = e[0]
    var v = e[1]
    var m = e[2]
    computeNKTg.call(x, v, m, dmDt)
}

System.print("============================================")
System.print("NKTg Law - Neptune 2024 Simulation")
System.print("============================================")

var data2024 = [
    [4498396440.0, 5.43, 1.02429900e26],
    [4503443661.0, 5.43, 1.02429880e26],
    [4553946490.0, 5.43, 1.02429860e26],
    [4503443661.0, 5.43, 1.02429840e26],
    [4498396440.0, 5.43, 1.02429820e26]
]

for (e in data2024) {
    var x = e[0]
    var v = e[1]
    var m = e[2]
    computeNKTg.call(x, v, m, dmDt)
}

System.print("============================================")
System.print("Experiment Completed")
System.print("============================================")
