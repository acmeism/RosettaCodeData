using IterTools

function floyd(f, x0)
    local tort = f(x0)
    local hare = f(tort)
    while tort != hare
        tort = f(tort)
        hare = f(f(hare))
    end

    local μ = 0
    tort = x0
    while tort != hare
        tort = f(tort)
        hare = f(hare)
        μ += 1
    end

    λ = 1
    hare = f(tort)
    while tort != hare
        hare = f(hare)
        λ += 1
    end

    return λ, μ
end

f(x) = (x * x + 1) % 255

λ, μ = floyd(f, 3)
cycle = iterate(f, 3) |>
    x -> Iterators.drop(x, μ) |>
    x -> Iterators.take(x, λ) |>
    collect
println("Cycle length: ", λ, "\nCycle start index: ", μ, "\nCycle: ", join(cycle, ", "))
