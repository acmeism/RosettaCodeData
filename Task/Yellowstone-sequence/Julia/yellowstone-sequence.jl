using Plots

function yellowstone(N)
    a = [1, 2, 3]
    b = Dict(1 => 1, 2 => 1, 3 => 1)
    start = 4
    while length(a) < N
        inseries = true
        for i in start:typemax(Int)
            if haskey(b, i)
                if inseries
                    start += 1
                end
            else
                inseries = false
            end
            if !haskey(b, i) && (gcd(i, a[end]) == 1) && (gcd(i, a[end - 1]) > 1)
                push!(a, i)
                b[i] = 1
                break
            end
        end
    end
    return a
end

println("The first 30 entries of the Yellowstone permutation:\n", yellowstone(30))

x = 1:100
y = yellowstone(100)
plot(x, y)
