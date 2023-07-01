using Random

struct GridPoint x::Int; y::Int end

const nrows, ncols, target = 8, 8, 12
const grid = fill('*', nrows, ncols)
const shapeletters = ['F', 'I', 'L', 'N', 'P', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
const shapevec = [
    [(1,-1, 1,0, 1,1, 2,1), (0,1, 1,-1, 1,0, 2,0),
        (1,0 , 1,1, 1,2, 2,1), (1,0, 1,1, 2,-1, 2,0), (1,-2, 1,-1, 1,0, 2,-1),
        (0,1, 1,1, 1,2, 2,1), (1,-1, 1,0, 1,1, 2,-1), (1,-1, 1,0, 2,0, 2,1)],
    [(0,1, 0,2, 0,3, 0,4), (1,0, 2,0, 3,0, 4,0)],
    [(1,0, 1,1, 1,2, 1,3), (1,0, 2,0, 3,-1, 3,0),
        (0,1, 0,2, 0,3, 1,3), (0,1, 1,0, 2,0, 3,0), (0,1, 1,1, 2,1, 3,1),
        (0,1, 0,2, 0,3, 1,0), (1,0, 2,0, 3,0, 3,1), (1,-3, 1,-2, 1,-1, 1,0)],
    [(0,1, 1,-2, 1,-1, 1,0), (1,0, 1,1, 2,1, 3,1),
        (0,1, 0,2, 1,-1, 1,0), (1,0, 2,0, 2,1, 3,1), (0,1, 1,1, 1,2, 1,3),
        (1,0, 2,-1, 2,0, 3,-1), (0,1, 0,2, 1,2, 1,3), (1,-1, 1,0, 2,-1, 3,-1)],
    [(0,1, 1,0, 1,1, 2,1), (0,1, 0,2, 1,0, 1,1),
        (1,0, 1,1, 2,0, 2,1), (0,1, 1,-1, 1,0, 1,1), (0,1, 1,0, 1,1, 1,2),
        (1,-1, 1,0, 2,-1, 2,0), (0,1, 0,2, 1,1, 1,2), (0,1, 1,0, 1,1, 2,0)],
    [(0,1, 0,2, 1,1, 2,1), (1,-2, 1,-1, 1,0, 2,0),
        (1,0, 2,-1, 2,0, 2,1), (1,0, 1,1, 1,2, 2,0)],
    [(0,1, 0,2, 1,0, 1,2), (0,1, 1,1, 2,0, 2,1),
        (0,2, 1,0, 1,1, 1,2), (0,1, 1,0, 2,0, 2,1)],
    [(1,0, 2,0, 2,1, 2,2), (0,1, 0,2, 1,0, 2,0),
        (1,0, 2,-2, 2,-1, 2,0), (0,1, 0,2, 1,2, 2,2)],
    [(1,0, 1,1, 2,1, 2,2), (1,-1, 1,0, 2,-2, 2,-1),
        (0,1, 1,1, 1,2, 2,2), (0,1, 1,-1, 1,0, 2,-1)],
    [(1,-1, 1,0, 1,1, 2,0)],
    [(1,-2, 1,-1, 1,0, 1,1), (1,-1, 1,0, 2,0, 3,0),
        (0,1, 0,2, 0,3, 1,1), (1,0, 2,0, 2,1, 3,0), (0,1, 0,2, 0,3, 1,2),
        (1,0, 1,1, 2,0, 3,0), (1,-1, 1,0, 1,1, 1,2), (1,0, 2,-1, 2,0, 3,0)],
    [(0,1, 1,0, 2,-1, 2,0), (1,0, 1,1, 1,2, 2,2),
        (0,1, 1,1, 2,1, 2,2), (1,-2, 1,-1, 1,0, 2,-2)]]
const shapes = Dict{Char,Vector{Vector{GridPoint}}}()
const placed = Dict{Char,Bool}()

for (ltr, vec) in zip(shapeletters, shapevec)
    shapes[ltr] = [[GridPoint(v[i], v[i + 1]) for i in 1:2:7] for v in vec]
    placed[ltr] = false
end

printgrid(m, w, h) = for x in 1:w for y in 1:h print(m[x, y], " ") end; println() end

function tryplaceorientation(o, R, C, shapeindex)
    for p in o
        r, c = R + p.x, C + p.y
        if r < 1 || r > nrows || c < 1 || c > ncols || grid[r, c] != '*'
            return false
        end
    end
    grid[R, C] = shapeindex
    for p in o
        grid[R + p.x, C + p.y] = shapeindex
    end
    true
end

function removeorientation(o, r, c)
    grid[r, c] = '*'
    for p in o
        grid[r + p.x, c + p.y] = '*'
    end
end

function solve(pos, nplaced)
    if nplaced == target
        return true
    end
    row, col = divrem(pos, ncols) .+ 1
    if grid[row, col] != '*'
        return solve(pos + 1, nplaced)
    end
    for i in keys((shapes))
        if !placed[i]
            for orientation in shapes[i]
                if tryplaceorientation(orientation, row, col, i)
                    placed[i] = true
                    if solve(pos + 1, nplaced + 1)
                        return true
                    else
                        removeorientation(orientation, row, col)
                        placed[i] = false
                    end
                end
            end
        end
    end
    false
end

function placepentominoes()
    for p in zip(shuffle(collect(1:nrows))[1:4], shuffle(collect(1:ncols))[1:4])
        grid[p[1], p[2]] = ' '
    end
    if solve(0, 0)
        printgrid(grid, nrows, ncols)
    else
        println("No solution found.")
    end
end

placepentominoes()
