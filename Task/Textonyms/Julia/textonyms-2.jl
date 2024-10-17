dname = "/usr/share/dict/american-english"
DF = open(dname, "r")
tnym = tpad(DF)
close(DF)

println("The character to digit mapping is done according to")
println("these regular expressions (following uppercase conversion):")
for k in sort(collect(keys(tcode)), by=x->tcode[x])
    println("    ", tcode[k], " -> ", k)
end
println("Unmatched non-digit characters are mapped to 1")

println()
print("There are ", sum(map(x->length(x), values(tnym))))
println(" words in ", dname)
println("  which can be represented by the digit key mapping.")
print("They require ", length(keys(tnym)))
println(" digit combinations to represent them.")
print(sum(map(x->length(x)>1, values(tnym))))
println(" digit combinations represent Textonyms.")

println()
println("The degeneracies of telephone key encodings are:")
println("  Words Encoded   Number of codes")
dgen = zeros(maximum(map(x->length(x), values(tnym))))
for v in values(tnym)
    dgen[length(v)] += 1
end
for (i, d) in enumerate(dgen)
    println(@sprintf "%10d  %15d" i d)
end

println()
dgen = length(dgen) - 2
println("Codes mapping to ", dgen, " or more words:")
for (k, v) in tnym
    dgen <= length(v) || continue
    println(@sprintf "%7s (%2d) %s" k length(v) join(v, ", "))
end
