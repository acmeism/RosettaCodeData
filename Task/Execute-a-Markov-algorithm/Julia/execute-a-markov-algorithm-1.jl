module MarkovAlgos

struct MarkovRule{F,T}
    patt::F
    repl::T
    term::Bool
end

isterminating(r::MarkovRule) = r.term
Base.show(io::IO, rule::MarkovRule) =
    print(io, rule.patt, " → ", isterminating(rule) ? "." : "", rule.repl)
function Base.convert(::Type{MarkovRule}, s::AbstractString)
    rmatch = match(r"^(.+)\s+->\s*(\.)?(.*)?$", s)
    if rmatch ≡ nothing || isempty(rmatch.captures)
        throw(ParseError("not valid rule: " * s))
    end
    patt, term, repl = rmatch.captures
    return MarkovRule(patt, repl ≢ nothing ? repl : "", term ≢ nothing)
end

function ruleset(file::Union{AbstractString,IO})
    ruleset = Vector{MarkovRule}(0)
    for line in eachline(file)
        ismatch(r"(^#|^\s*$)", line) || push!(ruleset, MarkovRule(line))
    end
    return ruleset
end

apply(text::AbstractString, rule::MarkovRule) = replace(text, rule.patt, rule.repl)
function apply(file::Union{AbstractString,IO}, ruleset::AbstractVector{<:MarkovRule})
    text = readstring(file)
    redo = !isempty(text)
    while redo
        matchrule = false
        for rule in ruleset
            if contains(text, rule.patt)
                matchrule = true
                text = apply(text, rule)
                redo = !isterminating(rule)
                break
            end
        end
        redo = redo && matchrule
    end
    return text
end

end  # module MarkovAlgos
