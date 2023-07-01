let negInf = -1.0 / 0.0
let inf = 1.0 / 0.0 //also Double.infinity
let nan = 0.0 / 0.0 //also Double.NaN
let negZero = -2.0 / inf

println("Negative inf: \(negInf)")
println("Positive inf: \(inf)")
println("NaN: \(nan)")
println("Negative 0: \(negZero)")
println("inf + -inf: \(inf + negInf)")
println("0 * NaN: \(0 * nan)")
println("NaN == NaN: \(nan == nan)")
