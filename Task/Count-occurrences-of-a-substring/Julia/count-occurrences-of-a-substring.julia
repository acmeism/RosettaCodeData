ts = ["the three truths", "ababababab"]
tsub = ["th", "abab"]

println("Test of non-overlapping substring counts.")
for i in 1:length(ts)
    print(ts[i], " (", tsub[i], ") => ")
    println(length(matchall(Regex(tsub[i]), ts[i])))
end
println()
println("Test of overlapping substring counts.")
for i in 1:length(ts)
    print(ts[i], " (", tsub[i], ") => ")
    println(length(matchall(Regex(tsub[i]), ts[i], true)))
end
