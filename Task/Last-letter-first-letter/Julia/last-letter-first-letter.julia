using IterTools.groupby

orderwords(words::Vector) = Dict(w[1][1] => Set(w) for w in groupby(first, words))
longest(a, b) = ifelse(length(a) > length(b), a, b)
function linkfirst(byfirst::Dict, sofar::Vector)
    @assert(!isempty(sofar))
    chmatch = sofar[end][end]
    if ! haskey(byfirst, chmatch) return sofar end
    options = setdiff(byfirst[chmatch], sofar)
    if isempty(options)
        return sofar
    else
        alternatives = ( linkfirst(byfirst, vcat(sofar, word)) for word in options )
        mx = reduce(longest, alternatives)
        return mx
    end
end
function llfl(words)
    byfirst = orderwords(words)
    alternatives = ( linkfirst(byfirst, [word]) for word in words )
    return reduce(longest, alternatives)
end

pokemon = String.(unique(split("""
    audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon
    cresselia croagunk darmanitan deino emboar emolga exeggcute gabite
    girafarig gulpin haxorus heatmor heatran ivysaur jellicent jumpluff kangaskhan
    kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine
    nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2
    porygonz registeel relicanth remoraid rufflet sableye scolipede scrafty seaking
    sealeo silcoon simisear snivy snorlax spoink starly tirtouga trapinch treecko
    tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask
    """)))

l = llfl(pokemon)
println("Example of longest seq.:\n", join(l, ", "))
println("Max length: ", length(l)
