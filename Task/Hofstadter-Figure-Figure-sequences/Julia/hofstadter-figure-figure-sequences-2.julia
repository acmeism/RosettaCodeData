NR = 40
NS = 960
ffr = make_ffr(NR)
ffs = make_ffs(NS)

hi = 10
print("The first ", hi, " values of R are:\n    ")
for i in 1:hi
    print(ffr(i), "  ")
end
println()

tally = falses(NR+NS)
iscontained = true
for i in 1:NR
    try
        tally[ffr(i)] = true
    catch
        iscontained = false
    end
end
for i in 1:NS
    try
        tally[ffs(i)] = true
    catch
        iscontained = false
    end
end

println()
print("The first ", NR, " values of R and ", NS, " of S are ")
if !iscontained
    print("not ")
end
println("contained in the interval 1:", NR+NS, ".")
print("These values ")
if !all(tally)
    print("do not ")
end
println("cover the entire interval.")
