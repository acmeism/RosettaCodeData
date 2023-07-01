def cube = { it * it * it }
def cubeRoot = { it ** (1/3) }

funcList = [ Math.&sin, Math.&cos, cube ]
inverseList = [ Math.&asin, Math.&acos, cubeRoot ]

println ([funcList, inverseList].transpose().collect { f, finv -> compose(f, finv) }.collect{ it(0.5) })
println ([inverseList, funcList].transpose().collect { finv, f -> compose(finv, f) }.collect{ it(0.5) })
