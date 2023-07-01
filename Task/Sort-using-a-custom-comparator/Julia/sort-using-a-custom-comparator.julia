wl = filter(!isempty, split("""You will rejoice to hear that no disaster has accompanied the
    commencement of an enterprise which you have regarded with such evil
    forebodings.""", r"\W+"))

println("Original list:\n - ", join(wl, "\n - "))
sort!(wl; by=x -> (-length(x), lowercase(x)))
println("\nSorted list:\n - ", join(wl, "\n - "))
