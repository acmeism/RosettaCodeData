function isabcword(w, _)
    positions = [findfirst(c -> c == ch, w) for ch in "abc"]
    return all(!isnothing, positions) && issorted(positions) ? w : ""
end

foreachword("unixdict.txt", isabcword)
