const topotext = """
top1    des1 ip1 ip2
top2    des1 ip2 ip3
ip1     extra1 ip1a ipcommon
ip2     ip2a ip2b ip2c ipcommon
des1    des1a des1b des1c
des1a   des1a1 des1a2
des1c   des1c1 extra1
"""

const topolines = map(x -> split(x, r"\s+", limit=2), split(strip(topotext), "\n"))
const topodict = Dict([p[1] => split(p[2], r"\s+") for p in topolines])

const dependents = collect(keys(topodict))
const dependencies = string.(unique(mapreduce(x -> topodict[x], vcat, dependents)))
const toplevel = string.(filter(x -> !(x in dependencies), dependents))

println("Top level files: ", toplevel)
println("Dependencies: $dependencies\n")

function compileorder(file, ddict)
    tocompile = [file]
    firstdependencies = get(ddict, file, [])
    if !isempty(firstdependencies)
        for f in firstdependencies
            append!(tocompile, reverse(compileorder(f, ddict)))
        end
    end
    return unique(reverse(tocompile))
end

for f in toplevel
    println("Compile order for $f: ", compileorder("top1", topodict))
end
