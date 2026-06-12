using Combinatorics
using Primes

const MASK = [false; primesmask(1000)]

""" Return true if vector v (of integers) is a prime grouping else false """
function isprimegroup(v::Vector{T}) where T <: Integer
    all(MASK[abs(v[i] - v[j])+1] for i in eachindex(v), j in eachindex(v) if i < j)
end

""" Get all prime groupings of each vector of a vector of integers. Each grouping
    should be such that all differences between elements in the group are prime numbers.
    Returns a vector of vectors, where each inner vector is a prime grouping.
"""
primegroupings(a) = [c for n in 2:4 for c in combinations(a, n) if isprimegroup(c)]

""" Count the number of prime groupings in a string of characters. The string is first
    converted to a vector of integers, where each character is represented by its
    ordinal value. If uniqueonly is true, it counts unique prime groupings from unique
    characters in the input. If uniqueonly is false (default), it counts all prime groupings
    and uses the order in the input of repeated characters to create additional mappings in
    the input to non-unique vectors in the output based on their original positions.
"""
function countprimegroupings(s::AbstractString, uniqueonly::Bool = false)
    if uniqueonly
        return s |> collect |> unique! .|> Int32 |> primegroupings |> sort! |> unique! |> length
    else
        return s |> collect .|> Int32 |> primegroupings |> length
    end
end

for _ in 1:1000
    print("Enter a string of characters, blank to exit: ")
    input = strip(readline())
    isempty(input) && break
    println("Total prime groupings: $(countprimegroupings(input)). ",
        "Unique: $(countprimegroupings(input, true)).")
end
