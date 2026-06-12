const alts = Set{String}()
function ischangeable(w, d)
    alternatives = [w[1:p[1]-1] * p[2] * w[p[1]+1:end] for p in Iterators.product(1:length(w), 'a':'z')]
    for a in alternatives
        if a != w && haskey(d, a)
            result = join(sort([w, a]), " <=> ")
            if !(result in alts)
                push!(alts, result)
                return result
            end
        end
    end
    return ""
end

foreachword("unixdict.txt", ischangeable, minlen = 12, colwidth=40, numcols=2)
