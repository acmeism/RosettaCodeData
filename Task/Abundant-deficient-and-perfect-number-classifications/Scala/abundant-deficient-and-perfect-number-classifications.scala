def properDivisors(n: Int) = (1 to n/2).filter(i => n % i == 0)
def classifier(i: Int) = properDivisors(i).sum compare i
val groups = (1 to 20000).groupBy( classifier )
println("Deficient: " + groups(-1).length)
println("Abundant: " + groups(1).length)
println("Perfect: " + groups(0).length + " (" + groups(0).mkString(",") + ")")
