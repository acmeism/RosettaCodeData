function sierpinski(n::Integer, token::AbstractString="*")
    x = fill(token, 1, 1)
    for _ in 1:n
        t = fill(" ", size(x))
        x = [x x x; x t x; x x x]
    end
    return x
end

function printsierpinski(m::Matrix)
    for r in 1:size(m, 1)
        println(join(m[r, :]))
    end
end

sierpinski(2, "#") |> printsierpinski
