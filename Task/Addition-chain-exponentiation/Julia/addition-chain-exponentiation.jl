import Base.iterate

mutable struct AdditionChains{T}
    chains::Vector{Vector{T}}
    work_chain::Int
    work_element::Int
    AdditionChains{T}() where T = new{T}([[one(T)]], 1, 1)
end

function Base.iterate(acs::AdditionChains, state = 1)
    i, j = acs.work_chain, acs.work_element
    newchain = [acs.chains[i]; acs.chains[i][end] + acs.chains[i][j]]
    push!(acs.chains, newchain)
    if j == length(acs.chains[i])
        acs.work_chain += 1
        acs.work_element = 1
    else
        acs.work_element += 1
    end
    return newchain, state + 1
end

function findchain!(acs::AdditionChains, n)
    @assert n > 0
    n == 1 && return [one(eltype(first(acs.chains)))]
    idx = findfirst(a -> a[end] == n, acs.chains)
    if idx == nothing
        for (i, chain) in enumerate(acs)
            chain[end] == n && return chain
        end
    end
    return acs.chains[idx]
end

""" memoization for knuth_path """
const knuth_path_p, knuth_path_lvl = Dict(1 => 0), [[1]]

""" knuth path method for addition chains """
function knuth_path(n)::Vector{Int}
    iszero(n) && return Int[]
    while !haskey(knuth_path_p, n)
        q = Int[]
        for x in first(knuth_path_lvl), y in knuth_path(x)
            if !haskey(knuth_path_p, x + y)
                knuth_path_p[x + y] = x
                push!(q, x + y)
            end
        end
        knuth_path_lvl[begin] = q
    end
    return push!(knuth_path(knuth_path_p[n]), n)
end

function pow(x, chain)
    p, products = 0, Dict{Int, typeof(x)}(0 => one(x), 1 => x)
    for i in chain
        products[i] = products[p] * products[i - p]
        p = i
    end
    return products[chain[end]]
end

function test_addition_chains()
    additionchain = AdditionChains{Int}()
    println("First one hundred addition chain lengths:")
    for i in 1:100
        print(rpad(length(findchain!(additionchain, i)) -1, 3), i % 10 == 0 ? "\n" : "")
    end
    println("\nKnuth chains for addition chains of 31415 and 27182:")
    expchains = Dict(i => knuth_path(i) for i in [31415, 27182])
    for (n, chn) in expchains
        println("Exponent: ", rpad(n, 10), "\n  Addition Chain: $(chn[begin:end-1]))")
    end
    println("\n1.00002206445416^31415 = ", pow(1.00002206445416, expchains[31415]))
    println("1.00002550055251^27182 = ", pow(1.00002550055251, expchains[27182]))
    println("1.00002550055251^(27182 * 31415) = ", pow(BigFloat(pow(1.00002550055251, expchains[27182])), expchains[31415]))
    println("(1.000025 + 0.000058i)^27182 = ", pow(Complex(1.000025, 0.000058), expchains[27182]))
    println("(1.000022 + 0.000050i)^31415 = ", pow(Complex(1.000022, 0.000050), expchains[31415]))
    x = sqrt(1/2)
    matrixA = [x 0 x 0 0 0; 0 x 0 x 0 0; 0 x 0 -x 0 0; -x 0 x 0 0 0; 0 0 0 0 0 1; 0 0 0 0 1 0]
    println("matrix A ^ 27182 = ")
    display(pow(matrixA, expchains[27182]))
    println("matrix A ^ 31415 = ")
    display(round.(pow(matrixA, expchains[31415]), digits=6))
    println("(matrix A ^ 27182) ^ 31415 = ")
    display(pow(pow(matrixA, expchains[27182]), expchains[31415]))
end

test_addition_chains()
