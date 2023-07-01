scores = [44, 42, 42, 41, 41, 41, 39]
names = ["Solomon", "Jason", "Errol", "Garry",
         "Bernard", "Barry", "Stephen"]

srank = rankstandard(scores)
mrank = rankmodified(scores)
drank = rankdense(scores)
orank = rankordinal(scores)
frank = rankfractional(scores)

println("    Name    Score  Std  Mod  Den  Ord  Frac")
for i in 1:length(scores)
    print(@sprintf("   %-7s", names[i]))
    print(@sprintf("%5d ", scores[i]))
    print(@sprintf("%5d", srank[i]))
    print(@sprintf("%5d", mrank[i]))
    print(@sprintf("%5d", drank[i]))
    print(@sprintf("%5d", orank[i]))
    print(@sprintf("%7.2f", frank[i]))
    println()
end
