# v0.6

function combsort!(x::Array)::Array
    gap, swaps = length(x), true
    while gap > 1 || swaps
        gap = floor(Int, gap / 1.25)
        i, swaps = 0, false
        while i + gap < length(x)
            if x[i+1] > x[i+1+gap]
                x[i+1], x[i+1+gap] = x[i+1+gap], x[i+1]
                swaps = true
            end
            i += 1
        end
    end
    return x
end

x = randn(100)
@show x combsort!(x)
@assert issorted(x)
