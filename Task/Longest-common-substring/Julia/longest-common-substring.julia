function lcs(s1::AbstractString, s2::AbstractString)::String
    l, r, sub_len = 1, 0, 0
    for i in eachindex(s1)
        for j in i:length(s1)
            contains(s2, SubString(s1, i, j)) || break
            if sub_len ≤ j - i
                l, r = i, j
                sub_len = j - i
            end
        end
    end
    return s1[l:r]
end

@show lcs("thisisatest", "testing123testing")
