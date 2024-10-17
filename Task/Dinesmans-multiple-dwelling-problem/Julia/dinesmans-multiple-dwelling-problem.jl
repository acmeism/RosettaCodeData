using Combinatorics

function solve(n::Vector{<:AbstractString}, pred::Vector{<:Function})
    rst = Vector{typeof(n)}(0)
    for candidate in permutations(n)
        if all(p(candidate) for p in predicates)
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
    (s) -> findfirst(s, "Miller") > findfirst(s, "Cooper"),
    (s) -> abs(findfirst(s, "Smith") - findfirst(s, "Fletcher")) != 1,
    (s) -> abs(findfirst(s, "Cooper") - findfirst(s, "Fletcher")) != 1]

solutions = solve(Names, predicates)
foreach(x -> println(join(x, ", ")), solutions)
