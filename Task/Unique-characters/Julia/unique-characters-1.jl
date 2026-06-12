list = ["133252abcdeeffd", "a6789798st", "yxcdfgxcyz"]

function is_once_per_all_strings_in(a::Vector{String})
    charlist = collect(prod(a))
    counts = Dict(c => count(x -> c == x, charlist) for c in unique(charlist))
    return sort([p[1] for p in counts if p[2] == 1])
end

println(is_once_per_all_strings_in(list))
