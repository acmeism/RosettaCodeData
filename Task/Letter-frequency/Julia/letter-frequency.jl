using DataStructures

function letterfreq(file::AbstractString; fltr::Function=(_) -> true)
    sort(Dict(counter(filter(fltr, read(file, String)))))
end

display(letterfreq("src/Letter_frequency.jl"; fltr=isletter))
