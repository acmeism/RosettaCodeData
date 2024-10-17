function check(i, j)
    id, im = div(i, 9), mod(i, 9)
    jd, jm = div(j, 9), mod(j, 9)

    jd == id && return true
    jm == im && return true

    div(id, 3) == div(jd, 3) &&
    div(jm, 3) == div(im, 3)
end

const lookup = zeros(Bool, 81, 81)

for i in 1:81
    for j in 1:81
        lookup[i,j] = check(i-1, j-1)
    end
end

function solve_sudoku(callback::Function, grid::Array{Int64})
    (function solve()
        for i in 1:81
            if grid[i] == 0
                t = Dict{Int64, Nothing}()

                for j in 1:81
                    if lookup[i,j]
                        t[grid[j]] = nothing
                    end
                end

                for k in 1:9
                    if !haskey(t, k)
                        grid[i] = k
                        solve()
                    end
                end

                grid[i] = 0
                return
            end
        end

        callback(grid)
    end)()
end

function display(grid)
    for i in 1:length(grid)
        print(grid[i], " ")
        i %  3 == 0 && print(" ")
        i %  9 == 0 && print("\n")
        i % 27 == 0 && print("\n")
    end
end

grid = Int64[5, 3, 0, 0, 2, 4, 7, 0, 0,
             0, 0, 2, 0, 0, 0, 8, 0, 0,
             1, 0, 0, 7, 0, 3, 9, 0, 2,
             0, 0, 8, 0, 7, 2, 0, 4, 9,
             0, 2, 0, 9, 8, 0, 0, 7, 0,
             7, 9, 0, 0, 0, 0, 0, 8, 0,
             0, 0, 0, 0, 3, 0, 5, 0, 6,
             9, 6, 0, 0, 1, 0, 3, 0, 0,
             0, 5, 0, 6, 9, 0, 0, 1, 0]

solve_sudoku(display, grid)
