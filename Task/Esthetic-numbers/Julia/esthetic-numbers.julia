using Formatting
import Base.iterate, Base.IteratorSize, Base.IteratorEltype

"""
    struct Esthetic

Used for iteration of esthetic numbers
"""
struct Esthetic{T}
    lowerlimit::T where T <: Integer
    base::T
    upperlimit::T
    Esthetic{T}(n, bas, m=typemax(T)) where T = new{T}(nextesthetic(n, bas), bas, m)
end

Base.IteratorSize(n::Esthetic) = Base.IsInfinite()
Base.IteratorEltype(n::Esthetic) = Integer
function Base.iterate(es::Esthetic, state=typeof(es.lowerlimit)[])
    state = isempty(state) ? digits(es.lowerlimit, base=es.base) : increment!(state, es.base, 1)
    n = toInt(state, es.base)
    return n <= es.upperlimit ? (n, state) : nothing
end

isesthetic(n, b) = (d = digits(n, base=b); all(i -> abs(d[i] - d[i + 1]) == 1, 1:length(d)-1))
toInt(dig, bas) = foldr((i, j) -> i + bas * j, dig)
nextesthetic(n, b) = for i in n:typemax(typeof(n)) if isesthetic(i, b) return i end; end

""" Fill the digits below pos in vector with the least esthetic number fitting there """
function filldecreasing!(vec, pos)
    if pos > 1
        n = vec[pos]
        for i in pos-1:-1:1
            n = (n == 0) ? 1 : n - 1
            vec[i] = n
        end
    end
    return vec
end

""" Get the next esthetic number's digits from the previous number's digits """
function increment!(vec, bas, startpos = 1)
    len = length(vec)
    if len == 1
        if vec[1] < bas - 1
            vec[1] += 1
        else
            vec[1] = 0
            push!(vec, 1)
        end
    else
        pos = findfirst(i -> vec[i] < vec[i + 1], startpos:len-1)
        if pos == nothing
            if vec[end] >= bas - 1
                push!(vec, 1)
                filldecreasing!(vec, len + 1)
            else
                vec[end] += 1
                filldecreasing!(vec, len)
            end
        else
            for i in pos:len
                if i == len
                    if vec[i] < bas - 1
                        vec[i] += 1
                        filldecreasing!(vec, i)
                    else
                        push!(vec, 1)
                        filldecreasing!(vec, len + 1)
                    end
                elseif vec[i] < vec[i + 1] && vec[i] < bas - 2
                    vec[i] += 2
                    filldecreasing!(vec, i)
                    break
                end
            end
        end
    end
    return vec
end

for b in 2:16
    println("For base $b, the esthetic numbers indexed from $(4b) to $(6b) are:")
    printed = 0
    for (i, n) in enumerate(Iterators.take(Esthetic{Int}(1, b), 6b))
        if i >= 4b
            printed += 1
            print(string(n, base=b), printed % 21 == 20 ? "\n" : " ")
        end
    end
    println("\n")
end

for (bottom, top, cols, T) in [[1000, 9999, 16, Int], [100_000_000, 130_000_000, 8, Int],
        [101_010_000_000, 130_000_000_000, 6, Int], [101_010_101_010_000_000, 130_000_000_000_000_000, 4, Int],
        [101_010_101_010_101_000_000, 130_000_000_000_000_000_000, 4, Int128]]
    esth, count = Esthetic{T}(bottom, 10, top), 0
    println("\nBase 10 esthetic numbers between $(format(bottom, commas=true)) and $(format(top, commas=true)):")
    for n in esth
        count += 1
        if count == 64
            println(" ...")
        elseif count < 64
            print(format(n, commas=true), count % cols == 0 ? "\n" : " ")
        end
    end
    println("\nTotal esthetic numbers in interval: $count")
end
