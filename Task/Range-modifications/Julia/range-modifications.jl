import Base.parse, Base.print, Base.reduce

const RangeSequence = Array{UnitRange, 1}

function combine!(seq::RangeSequence, r::UnitRange)
    isempty(seq) && return push!(seq, r)
    if r.start < seq[end].start
        reduce!(push!(seq, r))
    elseif r.stop > seq[end].stop
        if r.start <= seq[end].stop + 1
            seq[end] = seq[end].start:r.stop
        else
            push!(seq, r)
        end
    end
    return seq
end

function parse(::Type{RangeSequence}, s)
    seq = UnitRange[]
    entries = sort!(split(s, r"\s*,\s*"))
    for e in entries
        startstop = split(e, r"\:|\-")
        if length(startstop) == 2
            start, stop = tryparse(Int, startstop[1]), tryparse(Int, startstop[2])
            start, stop = start <= stop ? (start, stop) : (stop, start)
            start != nothing && stop != nothing && push!(seq, start:stop)
        elseif (n = tryparse(Int, startstop[1])) != nothing
            push!(seq, n:n)
        end
    end
    return reduce!(seq)
end

reduce!(a::RangeSequence) = (s = sort(a); empty!(a); for r in s combine!(a, r) end; a)
reduce(a::RangeSequence) = (seq = UnitRange[]; for r in sort(a) combine!(seq, r) end; seq)

insertinteger!(seq::RangeSequence, n::Integer) = begin push!(seq, n:n); reduce!(seq) end

insertintegerprint!(seq, n) = println("    added $n => ", insertinteger!(seq, n))
removeintegerprint!(seq, n) = println("    removed $n => ", removeinteger!(seq, n))

function removeinteger!(seq::RangeSequence, n::Integer)
    for (pos, r) in enumerate(seq)
        if n in r
            start, stop = r.start, r.stop
            if start == stop == n
                deleteat!(seq, pos:pos)
            elseif stop == n
                seq[pos] = start:stop-1
            elseif start == n
                seq[pos] = start+1:stop
            elseif start < n < stop
                seq[pos] = n+1:stop
                insert!(seq, pos, start:n-1)
            end
            break
        end
    end
    return seq
end

function print(io::IO, seq::RangeSequence)
    return print(io, "\"" * join(map(r -> "$(r.start)-$(r.stop)", reduce(seq)), ",") * "\"")
end

const seq = parse(RangeSequence, "")
println("Start: $seq")
insertintegerprint!(seq, 77)
insertintegerprint!(seq, 79)
insertintegerprint!(seq, 78)
removeintegerprint!(seq, 77)
removeintegerprint!(seq, 78)
removeintegerprint!(seq, 79)

const seq2 = parse(RangeSequence, "1-3, 5-5")
println("Start: $seq2")
insertintegerprint!(seq2, 1)
removeintegerprint!(seq2, 4)
insertintegerprint!(seq2, 7)
insertintegerprint!(seq2, 8)
insertintegerprint!(seq2, 6)
removeintegerprint!(seq2, 7)

const seq3 = parse(RangeSequence, "1-5, 10-25, 27-30")
println("Start: $seq3")
insertintegerprint!(seq3, 26)
insertintegerprint!(seq3, 9)
insertintegerprint!(seq3, 7)
removeintegerprint!(seq3, 26)
removeintegerprint!(seq3, 9)
removeintegerprint!(seq3, 7)

println("Parse \"10-25, 1-5, 27-30\" => ", parse(RangeSequence, "10-25, 1-5, 27-30"))
println("Parse \"3-1,15-5,25-10,30-27\" => ", parse(RangeSequence, "3-1,15-5,25-10,30-27"))
