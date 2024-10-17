julia> a  = :+
:+

julia> typeof(a)
Symbol

julia> b = quote + end
quote
    #= REPL[3]:1 =#
    +
end

julia> typeof(b)
Expr

julia> eval(a) == eval(b)
true

julia> c = :(2 + 3)
:(2 + 3)

julia> eval(c)
5
