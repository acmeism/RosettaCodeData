using Combinatorics

function solve(n::Vector{<:AbstractString}, pred::Vector{<:Function})
    rst = typeof(n)[]
    for candidate in permutations(n)
        if all(p(candidate) for p in pred)
            push!(rst, candidate)
        end
    end
    return rst
end

Names = ["Baker", "Cooper", "Fletcher", "Miller", "Smith"]
predicates = [
    (s) -> last(s) != "Baker",
    (s) -> first(s) != "Cooper",
    (s) -> first(s) != "Fletcher" && last(s) != "Fletcher",
    (s) -> findfirst(==("Miller"), s) > findfirst(==("Cooper"), s),
    (s) -> abs(findfirst(==("Smith"), s) - findfirst(==("Fletcher"), s)) != 1,
    (s) -> abs(findfirst(==("Cooper"), s) - findfirst(==("Fletcher"), s)) != 1]

solutions = solve(Names, predicates)
foreach(x -> println(join(x, ", ")), solutions)
