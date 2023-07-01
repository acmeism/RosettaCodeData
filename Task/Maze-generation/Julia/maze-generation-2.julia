pprint(matrix) = for i = 1:size(matrix, 1) println(join(matrix[i, :])) end
function printmaze(maze)
    walls = split("╹ ╸ ┛ ╺ ┗ ━ ┻ ╻ ┃ ┓ ┫ ┏ ┣ ┳ ╋")
    h, w = size(maze)
    f = cell -> 2 ^ ((3cell[1] + cell[2] + 3) / 2)
    wall(i, j) = if maze[i,j] == 0 " " else
        walls[Int(sum(f, filter(x -> maze[x...] != 0, neighbors([i, j], [h, w], 1)) .- [[i, j]]))]
    end
    mazewalls = collect(wall(i, j) for i in 1:2:h, j in 1:w)
    pprint(mazewalls)
end

printmaze(maze(10, 10))
