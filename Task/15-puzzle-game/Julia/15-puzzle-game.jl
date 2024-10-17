using Random

const size = 4
const puzzle = string.(reshape(1:16, size, size))
puzzle[16] = " "
rng = MersenneTwister(Int64(round(time())))
shufflepuzzle() = (puzzle .= shuffle(rng, puzzle))
findtile(t) = findfirst(x->x == t, puzzle)
findhole() = findtile(" ")

function issolvable()
    inversioncount = 1
    asint(x) = (puzzle[x] == " ") ? 0 : parse(Int64, puzzle[x])
    for i in 1:size^2-1, j in i:size^2
        if puzzle[i] == " " || puzzle[j] == " "
            continue
        end
        if parse(Int, puzzle[i]) < parse(Int, puzzle[j])
            inversioncount += 1
        end
    end
    if size % 2 == 1
        return inversioncount % 2 == 0
    end
    pos = findhole()
    inversioncount += pos[2]
    return inversioncount & 1 == 0
end

function nexttohole()
    holepos = findhole()
    row = holepos[1]
    col = holepos[2]
    if row == 1
        if col == 1
            return [[row, col + 1], [row + 1, col]]
        elseif col == size
            return [[row, col - 1], [row + 1, col]]
        else
            return [[row, col - 1], [row, col + 1], [row + 1, col]]
        end
    elseif row == size
        if col == 1
            return [[row - 1, col], [row, col + 1]]
        elseif col == size
            return [[row - 1, col], [row, col - 1]]
        else
            return [[row - 1, col], [row, col - 1], [row, col + 1]]
        end
    else
        if col == 1
            return [[row - 1, col], [row, col + 1], [row + 1, col]]
        elseif col == size
            return [[row - 1, col], [row, col - 1], [row + 1, col]]
        else
            return [[row - 1, col], [row, col - 1], [row, col + 1], [row + 1, col]]
        end
    end
end

possiblemoves() = map(pos->puzzle[pos[1], pos[2]], nexttohole())

function movehole(tiletofill)
    if tiletofill in possiblemoves()
        curpos = findtile(tiletofill)
        holepos = findhole()
        puzzle[holepos] = tiletofill
        puzzle[curpos] = " "
    else
        println("Bad tile move $tiletofill.\nPossible moves are $(possiblemoves()).")
    end
end

function printboard()
    ppuz(x,y) = print(lpad(rpad(puzzle[x,y], 3), 4), "|")
    print("+----+----+----+----+\n|")
    for j in 1:size, i in 1:size
        ppuz(i,j)
        if i == size
            print("\n")
            if j < size
                 print("|")
            end
        end
    end
    println("+----+----+----+----+")

end

function puzzle15play()
    solved() = (puzzle[1:15] == string.(1:15))
    shufflepuzzle()
    println("This puzzle is", issolvable() ? " " : " not ", "solvable.")
    while !solved()
        printboard()
        print("Possible moves are: $(possiblemoves()), 0 to exit. Your move? =>  ")
        s = readline()
        if s == "0"
            exit(0)
        end
        movehole(s)
    end
    printboard()
    println("Puzzle solved.")
end

puzzle15play()
