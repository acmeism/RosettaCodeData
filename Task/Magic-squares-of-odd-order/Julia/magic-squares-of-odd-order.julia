# v0.6.0

function magicsquareodd(base::Int)
    if base & 1 == 0 || base < 3; error("base must be odd and >3") end

    square = fill(0, base, base)
    r, number = 1, 1
    size = base * base

    c = div(base, 2) + 1
    while number ≤ size
        square[r, c] = number
        fr = r == 1 ? base : r - 1
        fc = c == base ? 1 : c + 1
        if square[fr, fc] != 0
            fr = r == base ? 1 : r + 1
            fc = c
        end
        r, c = fr, fc
        number += 1
    end

    return square
end

for n in 3:2:7
    println("Magic square with size $n - magic constant = ", div(n ^ 3 + n, 2))
    println("----------------------------------------------------")
    square = magicsquareodd(n)
    for i in 1:n
        println(square[i, :])
    end
    println()
end
