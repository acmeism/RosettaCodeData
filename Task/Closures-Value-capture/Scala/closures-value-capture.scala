val closures=for(i <- 0 to 9) yield (()=>i*i)
0 to 8 foreach (i=> println(closures(i)()))
println("---\n"+closures(7)())
