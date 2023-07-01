using Printf, IterTools, DataStructures

expr(p::String...)::String = @sprintf("%s1%s2%s3%s4%s5%s6%s7%s8%s9", p...)
function genexpr()::Vector{String}
    op = ["+", "-", ""]
    return collect(expr(p...) for (p) in Iterators.product(op, op, op, op, op, op, op, op, op) if p[1] != "+")
end

using DataStructures

function allexpr()::Dict{Int,Int}
    rst = DefaultDict{Int,Int}(0)
    for e in genexpr()
        val = eval(Meta.parse(e))
        rst[val] += 1
    end
    return rst
end

sumto(val::Int)::Vector{String} = filter(e -> eval(Meta.parse(e)) == val, genexpr())
function maxsolve()::Dict{Int,Int}
    ae = allexpr()
    vmax = maximum(values(ae))
    smax = filter(ae) do (v, f)
        f == vmax
    end
    return smax
end
function minsolve()::Int
    ae = keys(allexpr())
    for i in 1:typemax(Int)
        if i ∉ ae
            return i
        end
    end
end
function highestsums(n::Int)::Vector{Int}
    sums = collect(keys(allexpr()))
    return sort!(sums; rev=true)[1:n]
end

const solutions = sumto(100)
const smax = maxsolve()
const smin   = minsolve()
const hsums = highestsums(10)

println("100 =")
foreach(println, solutions)

println("\nMax number of solutions:")
for (v, f) in smax
    @printf("%3i -> %2i\n", v, f)
end

println("\nMin number with no solutions: $smin")

println("\nHighest sums representable:")
foreach(println, hsums)
