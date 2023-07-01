function tokenize2(s::AbstractString, sep::Char, esc::Char)
    SPE = "\ufffe"
    SPF = "\uffff"
    s = replace(s, "$esc$esc", SPE) |>
        s -> replace(s, "$esc$sep", SPF) |>
        s -> last(s) == esc ? string(replace(s[1:end-1], esc, ""), esc) : replace(s, esc, "")
    return map(split(s, sep)) do token
        token = replace(token, SPE, esc)
        return replace(token, SPF, sep)
    end
end

@show tokenize2("one^|uno||three^^^^|four^^^|^cuatro|", '|', '^')
