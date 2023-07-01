"""
# EightQueensPuzzle

Ported to **Julia** from examples in several languages from
here: https://hbfs.wordpress.com/2009/11/10/is-python-slow
"""
module EightQueensPuzzle

export Board, solve!

mutable struct Board
    cols::Int
    nodes::Int
    diag45::Int
    diag135::Int
    solutions::Int

    Board() = new(0, 0, 0, 0, 0)
end

"Marks occupancy."
function mark!(b::Board, k::Int, j::Int)
    b.cols    ⊻= (1 << j)
    b.diag135 ⊻= (1 << (j+k))
    b.diag45  ⊻= (1 << (32+j-k))
end

"Tests if a square is menaced."
function test(b::Board, k::Int, j::Int)
    b.cols    & (1 << j)        +
    b.diag135 & (1 << (j+k))    +
    b.diag45  & (1 << (32+j-k)) == 0
end

"Backtracking solver."
function solve!(b::Board, niv::Int, dx::Int)
    if niv > 0
        for i in 0:dx-1
            if test(b, niv, i) == true
                mark!(b, niv, i)
                solve!(b, niv-1, dx)
                mark!(b, niv, i)
            end
        end
    else
        for i in 0:dx-1
            if test(b, 0, i) == true
                b.solutions += 1
            end
        end
    end
    b.nodes += 1
    b.solutions
end

end # module

using  .EightQueensPuzzle

for n = 1:17
    b = Board()
    @show n
    print("elapsed:")
    solutions = @time solve!(b, n-1, n)
    @show solutions
    println()
end
