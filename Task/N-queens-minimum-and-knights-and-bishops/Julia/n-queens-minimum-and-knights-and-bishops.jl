""" Rosetta code task N-queens_minimum_and_knights_and_bishops """

import Cbc
using JuMP
using LinearAlgebra

""" Make a printable string from a matrix of zeros and ones using a char ch for 1, a period for !=1. """
function smatrix(x, n, ch)
    s = ""
    for i in 1:n, j in 1:n
        s *= lpad(x[i, j] == 1 ? "$ch" : ".", 2) * (j == n ? "\n" : "")
    end
    return s
end

""" N-queens minimum, oeis.org/A075458 """
function queensminimum(N, char = "Q")
    if  N < 4
        a = zeros(Int, N, N)
        a[N ÷ 2 + 1, N ÷ 2 + 1] = 1
        return 1, smatrix(a, N, char)
    end
    model = Model(Cbc.Optimizer)
    @variable(model, x[1:N, 1:N], Bin)

    for i in 1:N
        @constraint(model, sum(x[i, :]) <= 1)
        @constraint(model, sum(x[:, i]) <= 1)
    end
    for i in -(N - 1):(N-1)
        @constraint(model, sum(diag(x, i)) <= 1)
        @constraint(model, sum(diag(reverse(x, dims = 1), i)) <= 1)
    end
    for i in 1:N, j in 1:N
        @constraint(model, sum(x[i, :]) + sum(x[:, j]) +  sum(diag(x, j - i)) +
           sum(diag(rotl90(x), N - j - i + 1)) >= 1)
    end

    set_silent(model)
    @objective(model, Min, sum(x))
    optimize!(model)

    solution = round.(Int, value.(x))
    minresult = sum(solution)
    return minresult, smatrix(solution, N, char)
end

""" N-bishops minimum, same as N """
function bishopsminimum(N, char = "B")
    N == 1 && return 1, "$char"
    N == 2 && return 2, "$char .\n$char .\n"

    model = Model(Cbc.Optimizer)
    @variable(model, x[1:N, 1:N], Bin)

    for i in 1:N, j in 1:N
        @constraint(model, sum(diag(x, j - i)) + sum(diag(rotl90(x), N - j - i + 1)) >= 1)
    end

    set_silent(model)
    @objective(model, Min, sum(x))
    optimize!(model)

    solution = round.(Int, value.(x))
    minresult = sum(solution)
    return minresult, smatrix(solution, N, char)
end

""" N-knights minimum, oeis.org/A342576 """
function knightsminimum(N, char = "N")
    N < 2 && return 1, "$char"

    knightdeltas = [(1, 2), (2, 1), (2, -1), (1, -2), (-1, -2), (-2, -1), (-2, 1), (-1, 2)]

    model = Model(Cbc.Optimizer)

    # to simplify the constraints, embed the board of size N inside a board of size n + 4
    @variable(model, x[1:N+4, 1:N+4], Bin)

    @constraint(model, x[:, 1:2] .== 0)
    @constraint(model, x[1:2, :] .== 0)
    @constraint(model, x[:, N+3:N+4] .== 0)
    @constraint(model, x[N+3:N+4, :] .== 0)

    for i in 3:N+2, j in 3:N+2
        @constraint(model, x[i, j] + sum(x[i + d[1], j + d[2]] for d in knightdeltas) >= 1)
        @constraint(model, x[i, j] => {sum(x[i + d[1], j + d[2]] for d in knightdeltas) == 0})
    end

    set_silent(model)
    @objective(model, Min, sum(x))
    optimize!(model)

    solution = round.(Int, value.(x))
    minresult = sum(solution)
    return minresult, smatrix(solution[3:N+2, 3:N+2], N, char)
end

const examples = fill("", 3)
println("   Squares    Queens   Bishops   Knights")
@time for N in 1:10
    print(lpad(N^2, 10))
    i, examples[1] = queensminimum(N)
    print(lpad(i, 10))
    i, examples[2] = bishopsminimum(N)
    print(lpad(i, 10))
    i, examples[3] = knightsminimum(N)
    println(lpad(i, 10))
end

println("\nExamples for N = 10:\n\nQueens:\n", examples[1], "\nBishops:\n", examples[2],
   "\nKnights:\n", examples[3])

