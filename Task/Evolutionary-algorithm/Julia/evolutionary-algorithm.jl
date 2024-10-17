fitness(a::AbstractString, b::AbstractString) = count(l == t for (l, t) in zip(a, b))
function mutate(str::AbstractString, rate::Float64)
    L = collect(Char, " ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    return map(str) do c
        if rand() < rate rand(L) else c end
    end
end

function evolve(parent::String, target::String, mutrate::Float64, nchild::Int)
    println("Initial parent is $parent, its fitness is $(fitness(parent, target))")
    gens = 0
    while parent != target
        children = collect(mutate(parent, mutrate) for i in 1:nchild)
        bestfit, best = findmax(fitness.(children, target))
        parent = children[best]
        gens += 1
        if gens % 10 == 0
            println("After $gens generations, the new parent is $parent and its fitness is $(fitness(parent, target))")
        end
    end
    println("After $gens generations, the parent evolved into the target $target")
end

evolve("IU RFSGJABGOLYWF XSMFXNIABKT", "METHINKS IT IS LIKE A WEASEL", 0.08998, 100)
