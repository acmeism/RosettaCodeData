# v0.6

using Combinatorics

function permsort(x::Array)
    for perm in permutations(x)
        if issorted(perm)
            return perm
        end
    end
end

x = randn(10)
@show x permsort(x)
