function evolve(parent::String, target::String, mutrate::Float64, nchild::Int)
    fitness(a, b::String=target) = count(l == t for (l, t) in zip(a, b))
    function mutate(str::String, rate::Float64=mutrate)
        L = split(" ABCDEFGHIJKLMNOPQRSTUVWXYZ", "")
        r = collect(rand() < rate ? rand(L) : c for c in str)
        return string(r...)
    end
    println("Initial parent is $parent, its fitness is $(fitness(parent))")
    gens = 0
    while parent != target
        children = collect(mutate(parent, mutrate) for i in 1:nchild)
        bestfit, best = findmax(fitness.(children))
        parent = children[best]
        gens += 1
        if gens % 10 == 0
            println("After $gens generations, the new parent is $parent and its fitness is $(fitness(parent))")
        end
    end
    println("After $gens generations, the parent evolved into the target $target")
end

evolve("IU RFSGJABGOLYWF XSMFXNIABKT", "METHINKS IT IS LIKE A WEASEL", 0.08998, 100)
