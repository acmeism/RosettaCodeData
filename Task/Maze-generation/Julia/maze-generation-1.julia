using Random
check(bound::Vector) = cell -> all([1, 1] .≤ cell .≤ bound)
neighbors(cell::Vector, bound::Vector, step::Int=2) =
    filter(check(bound), map(dir -> cell + step * dir, [[0, 1], [-1, 0], [0, -1], [1, 0]]))

function walk(maze::Matrix, nxtcell::Vector, visited::Vector=[])
    push!(visited, nxtcell)
    for neigh in shuffle(neighbors(nxtcell, collect(size(maze))))
        if neigh ∉ visited
            maze[round.(Int, (nxtcell + neigh) / 2)...] = 0
            walk(maze, neigh, visited)
        end
    end
    maze
end
function maze(w::Int, h::Int)
    maze = collect(i % 2 | j % 2 for i in 1:2w+1, j in 1:2h+1)
    firstcell = 2 * [rand(1:w), rand(1:h)]
    return walk(maze, firstcell)
end
