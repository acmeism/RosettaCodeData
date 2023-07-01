Iterable.metaClass.mixin CartesianCategory

println "\nCore Solution:"
println "[1, 2] × [3, 4] = ${[1, 2] * [3, 4]}"
println "[3, 4] × [1, 2] = ${[3, 4] * [1, 2]}"
println "[1, 2] × [] = ${[1, 2] * []}"
println "[] × [1, 2] = ${[] * [1, 2]}"

println "\nExtra Credit:"
println "[1776, 1789] × [7, 12] × [4, 14, 23] × [0, 1] = ${[1776, 1789] * [7, 12] * [4, 14, 23] * [0, 1]}"
println "[1, 2, 3] × [30] × [500, 100] = ${[1, 2, 3] * [30] * [500, 100]}"
println "[1, 2, 3] × [] × [500, 100] = ${[1, 2, 3] * [] * [500, 100]}"

println "\nNon-Numeric Example:"
println "[John,Paul,George,Ringo] × [Emerson,Lake,Palmer] × [Simon,Garfunkle] = ["
( ["John","Paul","George","Ringo"] * ["Emerson","Lake","Palmer"] * ["Simon","Garfunkle"] ).each { println "\t${it}," }
println "]"
