s = "rosetta code phrase reversal"

println("The original phrase.")
println("   ", s)

println("Reverse the string.")
t = reverse(s)
println("   ", t)

println("Reverse each individual word in the string.")
t = join(map(reverse, split(s, " ")), " ")
println("   ", t)

println("Reverse the order of each word of the phrase.")
t = join(reverse(split(s, " ")), " ")
println("   ", t)
