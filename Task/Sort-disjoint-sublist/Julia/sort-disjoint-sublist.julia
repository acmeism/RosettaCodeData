function sortselected(a::AbstractVector{<:Real}, s::AbstractVector{<:Integer})
    sel = unique(sort(s))
    if sel[1] < 1 || length(a) < sel[end]
        throw(BoundsError())
    end
    b = collect(copy(a))
    b[sel] = sort(b[sel])
    return b
end

a = [7, 6, 5, 4, 3, 2, 1, 0]
sel = [7, 2, 8]
b = sortselected(a, sel)

println("Original: $a\n\tsorted on $sel\n -> sorted array: $b")
