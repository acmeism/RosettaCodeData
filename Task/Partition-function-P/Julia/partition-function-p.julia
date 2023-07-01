using Memoize

function partDiffDiff(n::Int)::Int
    isodd(n) ? (n+1)÷2 : n+1
end

@memoize function partDiff(n::Int)::Int
    n<2 ? 1 : partDiff(n-1)+partDiffDiff(n-1)
end

@memoize function partitionsP(n::Int)
    T=BigInt
    if n<2
        one(T)
    else
        psum = zero(T)
        for i ∈ 1:n
            pd = partDiff(i)
            if pd>n
                break
            end
            if ((i-1)%4)<2
                psum += partitionsP(n-pd)
            else
                psum -= partitionsP(n-pd)
            end
        end
        psum
    end
end

n=6666
@time println("p($n) = ", partitionsP(n))
