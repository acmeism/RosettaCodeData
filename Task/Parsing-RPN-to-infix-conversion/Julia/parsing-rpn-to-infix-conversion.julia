function parseRPNstring(rpns)
    infix = []
    rpn = split(rpns)
    for tok in rpn
        if all(isnumber, tok)
            push!(infix, parse(Int, tok))
        else
            last = pop!(infix)
            prev = pop!(infix)
            push!(infix, Expr(:call, Symbol(tok), prev, last))
            println("Current step: $infix")
        end
    end
    infix
end

unany(s) = replace(string(s), r"Any\[:\((.+)\)\]", s"\1")

println("The final infix result: ", parseRPNstring("3 4 2 * 1 5 - 2 3 ^ ^ / +") |> unany, "\n")
println("The final infix result: ", parseRPNstring("1 2 + 3 4 + ^ 5 6 + ^") |> unany)
