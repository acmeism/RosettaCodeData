function recaman()
    a = Vector{Int}([0])
    used = Dict{Int, Bool}(0 => true)
    used1000 = Set(0)
    founddup = false
    termcount = 1
    while length(used1000) <= 1000
        nextterm = a[termcount] - termcount
        if nextterm < 1 || haskey(used, nextterm)
            nextterm += termcount + termcount
        end
        push!(a, nextterm)
        if !haskey(used, nextterm)
            used[nextterm] = true
            if 1 <= nextterm <= 1000
                push!(used1000, nextterm)
            end
        elseif !founddup
            println("The first duplicated term is a[$(termcount + 1)] = $nextterm.")
            founddup = true
        end
        if termcount == 14
            println("The first 15 terms of the Recaman sequence are $a")
        end
        termcount += 1
    end
    println("Terms up to $(termcount - 1) are needed to generate 0 to 1000.")
end

recaman()
