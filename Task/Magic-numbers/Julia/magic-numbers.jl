function findmagics(maxdig = 26)
    magics = [Int128[] for _ in 1:maxdig-1]
    pushfirst!(magics, collect(one(Int128):9))
    for n in 2:maxdig, i in magics[n - 1], j in 0:9
        k = 10i + j
        k % n == 0 && push!(magics[n], k)
    end
    pushfirst!(first(magics), 0) # zero is a one-digit magic number?
    return magics
end

const magics = findmagics()

for (n, arr) in enumerate(magics)
    println("There are $(length(arr)) magic numbers with $n digits",
       isempty(arr) ? "." : " with the largest $(last(arr)).")
end
println("\nIn all, there are $(sum(map(length, magics))) magic numbers.\n")

println("Magic number(s) pan-digital in 1 through 9 with no repeats: ",
    join(filter(n -> (d = digits(n); all(i -> count(==(i), d) == 1, 1:9)), magics[9])))
println("Magic number(s) pan-digital in 0 through 9 with no repeats: ",
    join(filter(n -> (d = digits(n); all(i -> count(==(i), d) == 1, 0:9)), magics[10])))

