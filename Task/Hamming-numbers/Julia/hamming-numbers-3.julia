function trival((twos, threes, fives))
    BigInt(2)^twos * BigInt(3)^threes * BigInt(5)^fives
end

mutable struct Hammings
    ham532 :: Vector{Tuple{Float64,Tuple{Int,Int,Int}}}
    ham53 :: Vector{Tuple{Float64,Tuple{Int,Int,Int}}}
    ndx532 :: Int
    ndx53 :: Int
    next2 :: Tuple{Float64,Tuple{Int,Int,Int}}
    next3 :: Tuple{Float64,Tuple{Int,Int,Int}}
    next5 :: Tuple{Float64,Tuple{Int,Int,Int}}
    next53 :: Tuple{Float64,Tuple{Int,Int,Int}}
    Hammings() = new(
        Vector{Tuple{Float64,Tuple{Int,Int,Int}}}(),
        Vector{Tuple{Float64,Tuple{Int,Int,Int}}}(),
        1, 1,
        (1.0, (1, 0, 0)), (log(2, 3), (0, 1, 0)),
        (log(2, 5), (0, 0, 1)), (0.0, (0, 0, 0))
    )
end
Base.eltype(::Type{Hammings}) = Tuple{Int,Int,Int}
function Base.iterate(HM::Hammings, st = HM) # :: Union{Nothing,Tuple{Tuple{Float64,Tuple{Int,Int,Int}},Hammings}}
    log2of2, log2of3, log2of5 = 1.0, log(2,3), log(2,5)
    if st.next2[1] < st.next53[1]
        push!(st.ham532, st.next2); st.ndx532 += 1
        last, (twos, threes, fives) = st.ham532[st.ndx532]
        st.next2 = (log2of2 + last, (twos + 1, threes, fives))
    else
        push!(st.ham532, st.next53)
        if st.next3[1] < st.next5[1]
            st.next53 = st.next3; push!(st.ham53, st.next3)
            last, (_, threes, fives) = st.ham53[st.ndx53]; st.ndx53 += 1
            st.next3 = (log2of3 + last, (0, threes + 1, fives))
        else
            st.next53 = st.next5; push!(st.ham53, st.next5)
            last, (_, _, fives) = st.next5
            st.next5 = (log2of5 + last, (0, 0, fives + 1))
        end
    end
    len53 = length(st.ham53)
    if st.ndx53 > (len53 >>> 1)
        nlen53 = len53 - st.ndx53 + 1
        copyto!(st.ham53, 1, st.ham53, st.ndx53, nlen53)
        resize!(st.ham53, nlen53); st.ndx53 = 1
    end
    len532 = length(st.ham532)
    if st.ndx532 > (len532 >>> 1)
        nlen532 = len532 - st.ndx532 + 1
        copyto!(st.ham532, 1, st.ham532, st.ndx532, nlen532)
        resize!(st.ham532, nlen532); st.ndx532 = 1
    end
    _, tri = st.ham532[end]
    tri, st
#    convert(Union{Nothing,Tuple{Tuple{Float64,Tuple{Int,Int,Int}},Hammings}},(st.ham532[end], st))
#   (length(st.ham532), length(st.ham53)), st
end

foreach(x -> print(trival(x)," "), (Iterators.take(Hammings(), 20))); println()
let count = 1691; for t in Hammings() count <= 1 && (println(trival(t)); break); count -= 1 end end
let count = 1000000; for t in Hammings() count <= 1 && (println(trival(t)); break); count -= 1 end end
