module Chess

using Printf

struct King end
struct Pawn end

function placepieces!(grid, ::King)
    axis = axes(grid, 1)
    while true
        r1, c1, r2, c2 = rand(axis, 4)
        if r1 != r2 && abs(r1 - r2) > 1 && abs(c1 - c2) > 1
            grid[r1, c1] = '♚'
            grid[r2, c2] = '♔'
            return grid
        end
    end
end

function placepieces!(grid, ch)
    axis = axes(grid, 1)
    while true
        r, c = rand(axis, 2)
        if grid[r, c] == ' '
            grid[r, c] = ch
            return grid
        end
    end
end

function placepieces!(grid, ch, ::Pawn)
    axis = axes(grid, 1)
    while true
        r, c = rand(axis, 2)
        if grid[r, c] == ' ' && r ∉ extrema(axis)
            grid[r, c] = ch
            return grid
        end
    end
end

function randposition!(grid)
    placepieces!(grid, King())
    foreach("♙♙♙♙♙♙♙♙♙♟♟♟♟♟♟♟♟") do ch
        placepieces!(grid, ch, Pawn())
    end
    foreach("♖♘♗♕♗♘♖♜♞♝♛♝♞♜") do ch
        placepieces!(grid, ch)
    end
    return grid
end

printgrid(grid) = println(join((join(grid[r, :], ' ') for r in 1:size(grid, 1)), '\n'))

end  # module Chess
