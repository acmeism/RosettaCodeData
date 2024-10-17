struct LogRep
    lg :: Float64
    x2 :: UInt32
    x3 :: UInt32
    x5 :: UInt32
end
const ONE = LogRep(0.0, 0, 0, 0)
const LB2_2 = 1.0
const LB2_3 = log(2,3)
const LB2_5 = log(2,5)
function mult2(lr :: LogRep) # :: LogRep
    LogRep(lr.lg + LB2_2, lr.x2 + 1, lr.x3, lr.x5)
end
function mult3(lr :: LogRep) # :: LogRep
    LogRep(lr.lg + LB2_3, lr.x2, lr.x3 + 1, lr.x5)
end
function mult5(lr :: LogRep) # :: LogRep
    LogRep(lr.lg + LB2_5, lr.x2, lr.x3, lr.x5 + 1)
end
function lr2BigInt(lr :: LogRep) # :: BigInt
    BigInt(2)^lr.x2 * BigInt(3)^lr.x3 * BigInt(5)^lr.x5
end

mutable struct HammingsLog
    s2 :: Vector{LogRep}
    s3 :: Vector{LogRep}
    s5 :: LogRep
    mrg :: LogRep
    s2hdi :: Int
    s3hdi :: Int
    HammingsLog() = new(
        [ONE],
        [mult3(ONE)],
        mult5(ONE),
        mult3(ONE),
        1, 1
    )
end
Base.eltype(::Type{HammingsLog}) = LogRep
function Base.iterate(HM::HammingsLog, st = HM) # :: Union{Nothing,Tuple{LogRep,HammingsLog}}
    s2sz = length(st.s2)
    if st.s2hdi + st.s2hdi - 2 >= s2sz
        ns2sz = s2sz - st.s2hdi + 1
        copyto!(st.s2, 1, st.s2, st.s2hdi, ns2sz)
        resize!(st.s2, ns2sz); st.s2hdi = 1
    end
    rslt = @inbounds(st.s2[st.s2hdi])
    if rslt.lg < st.mrg.lg
        st.s2hdi += 1
    else
        s3sz = length(st.s3)
        if st.s3hdi + st.s3hdi - 2 >= s3sz
            ns3sz = s3sz - st.s3hdi + 1
            copyto!(st.s3, 1, st.s3, st.s3hdi, ns3sz)
            resize!(st.s3, ns3sz); st.s3hdi = 1
        end
        rslt = st.mrg; push!(st.s3, mult3(rslt))
        st.s3hdi += 1; chkv = @inbounds(st.s3[st.s3hdi])
        if chkv.lg < st.s5.lg
            st.mrg = chkv
        else
            st.mrg = st.s5; st.s5 = mult5(st.s5); st.s3hdi -= 1
        end
    end
    push!(st.s2, mult2(rslt)); rslt, st
end

function test(n :: Int) :: Tuple{LogRep, Float64}
    start = time(); rslt :: LogRep = ONE
    count = n; for t in HammingsLog() count <= 1 && (rslt = t; break); count -= 1 end
    elpsd = (time() - start) * 1000
    rslt, elpsd
end

foreach(x -> print(lr2BigInt(x)," "), (Iterators.take(HammingsLog(), 20))); println()
let count = 1691; for t in HammingsLog() count <= 1 && (println(lr2BigInt(t)); break); count -= 1 end end
rslt, elpsd = test(1000000)
println(lr2BigInt(rslt))
println("This last took $elpsd milliseconds.")
