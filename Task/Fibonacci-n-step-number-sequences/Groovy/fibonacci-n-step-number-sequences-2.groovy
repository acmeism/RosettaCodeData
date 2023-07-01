[
    ' fibonacci':[1,1],
    'tribonacci':[1,1,2],
    'tetranacci':[1,1,2,4],
    'pentanacci':[1,1,2,4,8],
    ' hexanacci':[1,1,2,4,8,16],
    'heptanacci':[1,1,2,4,8,16,32],
    ' octonacci':[1,1,2,4,8,16,32,64],
    ' nonanacci':[1,1,2,4,8,16,32,64,128],
    ' decanacci':[1,1,2,4,8,16,32,64,128,256],
    '     lucas':[2,1],
].each { name, seed ->
    println "${name}: ${fib(seed,10)}"
}

println "  lucas[0]: ${fib([2,1],0)}"
println "  tetra[3]: ${fib([1,1,2,4],3)}"
