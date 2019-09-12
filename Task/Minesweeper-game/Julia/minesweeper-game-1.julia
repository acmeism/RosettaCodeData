# Minesweeper:

mutable struct Field
    size::Tuple{Int, Int}
    numbers::Array{Int, 2}
    possible_mines::Array{Bool, 2}
    actual_mines::Array{Bool, 2}
    visible::Array{Bool, 2}
end

function Field(x, y)
    size = (x, y)
    actual_mines = convert(Array{Bool, 2}, rand(x, y) .< 0.15)
    possible_mines = zeros(Bool, x, y)
    numbers = zeros(Int, x, y)
    visible = zeros(Bool, x, y)
    for i = 1:x
        for j = 1:y
            n = 0
            for di = -1:1
                for dj = -1:1
                    n += (0 < di+i <= x && 0 < dj+j <= y) ?
                         (actual_mines[di+i, dj+j] ? 1 : 0) : 0
                end
            end
            numbers[i, j] = n
        end
    end
    return Field(size, numbers, possible_mines, actual_mines, visible)
end

function printfield(f::Field; showall = false)
    spaces = Int(floor(log(10, f.size[2])))

    str = " "^(4+spaces)
    for i in 1:f.size[1]
        str *= string(" ", i, " ")
    end
    str *= "\n" * " "^(4+spaces) * "___"^f.size[1] * "\n"
    for j = 1:f.size[2]
        str *= " " * string(j) * " "^(floor(log(10, j)) > 0 ? 1 : spaces+1) * "|"
        for i = 1:f.size[1]
            if showall
                str *= f.actual_mines[i, j] ? " * " : "   "
            else
                if f.visible[i, j]
                    str *= " " * string(f.numbers[i, j] > 0 ? f.numbers[i, j] : " ") * " "
                elseif f.possible_mines[i, j]
                    str *= " ? "
                else
                    str *= " . "
                end
            end
        end
        str *= "\r\n"
    end
    println("Found " * string(length(f.possible_mines[f.possible_mines.==true])) *
            " of " * string(length(f.actual_mines[f.actual_mines.==true])) * " mines.\n")
    print(str)
end

function parse_input(str::String)
    input = split(chomp(str), " ")
    mode = input[1]
    println(str)
    coords =  length(input) > 1 ? (parse(Int,input[2]), parse(Int,input[3])) : (0, 0)
    return mode, coords
end

function eval_input(f::Field, str::String)
    mode, coords = parse_input(str)
    (coords[1] > f.size[1] || coords[2] > f.size[2]) && return true
    if mode == "o"
        reveal(f, coords...) || return false
    elseif mode == "m" && f.visible[coords...] == false
        f.possible_mines[coords...] = !f.possible_mines[coords...]
    elseif mode == "close"
        error("You closed the game.")
    end
    return true
end

function reveal(f::Field, x::Int, y::Int)
    (x > f.size[1] || y > f.size[2]) && return true # check for index out of bounds
    f.actual_mines[x, y] && return false # check for mines
    f.visible[x, y] = true
    if f.numbers[x, y] == 0
        for di = -1:1
            for dj = -1:1
                if (0 < di+x <= f.size[1] && 0 < dj+y <= f.size[2]) &&
                        f.actual_mines[x+di, y+dj] == false &&
                        f.visible[x+di, y+dj] == false
                    reveal(f, x+di, y+dj)
                end
            end
        end
    end
    return true
end

function play()
    print("\nWelcome to Minesweeper\n\nEnter the gridsize x  y:\n")
    s = split(readline(), " ")
    f = Field(parse.(Int,s)...)
    won = false
    while true
        printfield(f)
        print("\nWhat do you do? (\"o x y\" to reveal a field; \"m x y\" to toggle a mine; close)\n")
        eval_input(f, readline()) || break
        print("_"^80 * "\n")
        (f.actual_mines == f.possible_mines ||
              f.visible == .!f.actual_mines) && (won = true; break)
    end
    println(won ? "You won the game!" : "You lost the game:\n")
    printfield(f, showall = true)
end

play()
