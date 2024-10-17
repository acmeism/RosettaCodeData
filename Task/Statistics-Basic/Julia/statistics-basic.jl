using Printf

function hist(numbers)
    maxwidth = 50
    h = fill(0, 10)
    for n in numbers
        h[ceil(Int, 10n)] += 1
    end
    mx = maximum(h)
    for (n, i) in enumerate(h)
        @printf("%3.1f: %s\n", n / 10, "+" ^ floor(Int, i / mx * maxwidth))
    end
end

for i in 1:6
    n = rand(10 ^ i)
    println("\n##\n## $(10 ^ i) numbers")
    @printf("μ: %8.6f; σ: %8.6f\n", mean(n), std(n))
    hist(n)
end
