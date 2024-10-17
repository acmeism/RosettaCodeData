using BenchmarkTools
println("\n# levendist(kitten, sitting)")
s, t = "kitten", "sitting"
println(" - Recursive:")
@btime levendist(s, t)
println(" - Iterative:")
@btime levendist1(s, t)
println("\n# levendist(rosettacode, raisethysword)")
s, t = "rosettacode", "raisethysword"
println(" - Recursive:")
@btime levendist(s, t)
println(" - Iterative:")
@btime levendist1(s, t)
