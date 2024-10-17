module StateNamePuzzle

const realnames = ["Alabama", "Alaska", "Arizona", "Arkansas", "California",
"Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho",
"Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine",
"Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri",
"Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico",
"New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon",
"Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
"Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
"Wisconsin", "Wyoming"]

const fictitious = ["New Kory", "Wen Kory", "York New", "Kory New", "New Kory"]

function combine(a::AbstractString, b::AbstractString)
    chars = vcat(collect(Char, a), collect(Char, b))
    sort!(chars)
    return join(chars)
end

function solve(input::Vector{<:AbstractString})
    dict = Dict{String,String}()
    for state in input
        key = replace(state, " ", "") |> lowercase
        if !haskey(dict, key)
            dict[key] = state
        end
    end
    keyset = collect(keys(dict))
    solutions = String[]
    duplicates = String[]
    for i in eachindex(keyset), j in (i+1):endof(keyset)
        len1 = length(keyset[i]) + length(keyset[j])
        combined1 = combine(keyset[i], keyset[j])
        for k in eachindex(keyset), l in k+1:endof(keyset)
            k ∈ (i, j) && continue
            l ∈ (i, j) && continue
            len2 = length(keyset[k]) + length(keyset[l])
            len1 != len2 && continue
            combined2 = combine(keyset[k], keyset[l])
            if combined1 == combined2
                f1 = dict[keyset[i]] * " + " * dict[keyset[j]]
                f2 = dict[keyset[k]] * " + " * dict[keyset[l]]
                f3 = f1 * " = " * f2
                f3 ∈ duplicates && continue
                push!(solutions, f3)
                f4 = f2 * " = " * f1
                push!(duplicates, f4)
            end
        end
    end
    return sort!(solutions)
end

end  # module StateNamePuzzle
