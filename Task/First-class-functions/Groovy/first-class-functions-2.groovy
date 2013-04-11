def cube = { it * it * it }
def cubeRoot = { it ** (1/3) }

funcList = [ Math.&sin, Math.&cos, cube ]
inverseList = [ Math.&asin, Math.&acos, cubeRoot ]

println [funcList, inverseList].transpose().collect { compose(it[0],it[1]) }.collect{ it(0.5) }
println [inverseList, funcList].transpose().collect { compose(it[0],it[1]) }.collect{ it(0.5) }
