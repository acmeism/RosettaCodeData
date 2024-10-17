const Prime = UInt64
abstract type PrimesDictAbstract end # used for forward reference
mutable struct PrimesDict <: PrimesDictAbstract
    sieve :: Dict{Prime,Prime}
    baseprimes :: PrimesDictAbstract
    lastbaseprime :: Prime
    q :: Prime
    PrimesDict() = new(Dict())
end
Base.eltype(::Type{PrimesDict}) = Prime
Base.IteratorSize(::Type{PrimesDict}) = Base.SizeUnknown() # "infinite"...
function Base.iterate(PD::PrimesDict, state::Prime = Prime(0) )
    if state < 1
        PD.baseprimes = PrimesDict()
        PD.lastbaseprime = Prime(3)
        PD.q = Prime(9)
        return Prime(2), Prime(1)
    end
    dict = PD.sieve
    while true
        state += 2
        if !haskey(dict, state)
            state < PD.q && return state, state
            p = PD.lastbaseprime # now, state = PD.q in all cases
            adv = p + p # since state is at PD.q, advance to next
            dict[state + adv] = adv # adds base prime composite stream
            # following initializes secondary base strea first time
            p <= 3 && Base.iterate(PD.baseprimes)
            p = Base.iterate(PD.baseprimes, p)[1] # next base prime
            PD.lastbaseprime = p
            PD.q = p * p
        else # advance hit composite in dictionary...
            adv = pop!(dict, state)
            next = state + adv
            while haskey(dict, next) next += adv end
            dict[next] = adv # past other composite hits in dictionary
        end
    end
end
