using Random

const stepdirections = [[1, 0], [0, 1], [1, 1], [1, -1], [-1, 0], [0, -1], [-1, -1], [-1, 1]]
const nrows    = 10
const ncols    = nrows
const gridsize = nrows * ncols
const minwords = 25
const minwordsize = 3

mutable struct LetterGrid
    nattempts::Int
    nrows::Int
    ncols::Int
    cells::Matrix{Char}
    solutions::Vector{String}
    LetterGrid() = new(0, nrows, ncols, fill(' ', nrows, ncols), Vector{String}())
end

function wordmatrix(filename, usepropernames = true)
    words = [lowercase(line) for line in readlines(filename)
        if match(r"^[a-zA-Z]+$", line) != nothing && (usepropernames ||
            match(r"^[a-z]", line) != nothing) && length(line) >= minwordsize && length(line) <= ncols]
    n = 1000
    for i in 1:n
        grid = LetterGrid()
        messagelen = placemessage(grid, "Rosetta Code")
        target = grid.nrows * grid.ncols - messagelen
        cellsfilled = 0
        shuffle!(words)
        for word in words
            cellsfilled += tryplaceword(grid, word)
            if cellsfilled == target
                if length(grid.solutions) >= minwords
                    grid.nattempts = i
                    return grid
                else
                    break
                end
            end
        end
    end
    throw("Failed to place words after $n attempts")
end

function placemessage(grid, msg)
    msg = uppercase(msg)
    msg = replace(msg, r"[^A-Z]" => "")
    messagelen = length(msg)
    if messagelen > 0 && messagelen < gridsize
        p = Int.(floor.(LinRange(messagelen, gridsize, messagelen) .+
                     (rand(messagelen) .- 0.5) * messagelen / 3)) .- div(messagelen, 3)
        foreach(i -> grid.cells[div(p[i], nrows) + 1, p[i] % nrows + 1] = msg[i], 1:length(p))
        return messagelen
    end
    return 0
end

function tryplaceword(grid, word)
    for dir in shuffle(stepdirections)
        for pos in shuffle(1:length(grid.cells))
            lettersplaced = trylocation(grid, word, dir, pos)
            if lettersplaced > 0
                return lettersplaced
            end
        end
    end
    return 0
end

function trylocation(grid, word, dir, pos)
    r, c = divrem(pos, nrows) .+ [1, 1]
    positions = [[r, c] .+ (dir .* i) for i in 1:length(word)]
    if !all(x -> 0 < x[1] <= nrows && 0 < x[2] <= ncols, positions)
        return 0
    end
    for (i, p) in enumerate(positions)
        letter = grid.cells[p[1],p[2]]
        if letter != ' ' && letter != word[i]
            return 0
        end
    end
    lettersplaced = 0
    for (i, p) in enumerate(positions)
        if grid.cells[p[1], p[2]] == ' '
            lettersplaced += 1
            grid.cells[p[1],p[2]] = word[i]
        end
    end
    if lettersplaced > 0
        push!(grid.solutions, lpad(word, 10) * " $(positions[1]) to $(positions[end])")
    end
    return lettersplaced
end

function printresult(grid)
    if grid.nattempts == 0
        println("No grid to display: no solution found.")
        return
    end
    size = length(grid.solutions)
    println("Attempts: ", grid.nattempts)
    println("Number of words: ", size)
    println("\n     0  1  2  3  4  5  6  7  8  9")
    for r in 1:nrows
        print("\n", rpad(r, 4))
        for c in 1:ncols
            print(" $(grid.cells[r, c]) ")
        end
    end
    println()
    for i in 1:2:size
        println("$(grid.solutions[i])   $(i < size ? grid.solutions[i+1] : "")")
    end
end

printresult(wordmatrix("words.txt", false))
