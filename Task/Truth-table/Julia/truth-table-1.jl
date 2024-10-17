module TruthTable

using Printf
using MacroTools

isvariablename(::Any) = false
isvariablename(s::Symbol) = all(x -> isletter(x) || x == '_', string(s))

function table(expr)
    if !isvariablename(expr) && !Meta.isexpr(expr, :call)
        throw(ArgumentError("expr must be a boolean expression"))
    end

    exprstr = string(expr)
    # Collect variable names
    symset = Set{Symbol}()
    MacroTools.prewalk(expr) do node
        isvariablename(node) && push!(symset, node)
        return node
    end
    symlist = collect(symset)

    # Create assignment assertions + evaluate
    blocks = Vector{Expr}(undef, 2 ^ length(symlist) + 1)
    blocks[1] = quote
        println(join(lpad.($(symlist), 6), " | "), " || ", $exprstr)
    end
    for (i, tup) in enumerate(Iterators.product(Iterators.repeated((false, true), length(symlist))...))
        blocks[i + 1] = quote
            let $(Expr(:(=), Expr(:tuple, symlist...), Expr(:tuple, tup...)))
                println(join(lpad.($(Expr(:tuple, symlist...)), 6), " | "), " || ", lpad($expr, $(length(exprstr))))
            end
        end
    end

    return esc(Expr(:block, blocks...))
end

macro table(expr)
    return table(expr)
end

end  # module TruthTable
