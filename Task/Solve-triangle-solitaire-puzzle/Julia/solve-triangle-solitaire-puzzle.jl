moves = [[1, 2, 4], [1, 3, 6], [2, 4, 7], [2, 5, 9], [3, 5, 8], [3, 6, 10], [4, 5, 6],
         [4, 7, 11], [4, 8, 13], [5, 8, 12], [5, 9, 14], [6, 9, 13], [6, 10, 15],
         [7, 8, 9], [8, 9, 10],  [11, 12, 13], [12, 13, 14], [13, 14, 15]]

triangletext(v) = join(map(i -> " "^([6,4,3,1,0][i]) * join(map(x -> rpad(x, 3),
    v[div(i*i-i+2,2):div(i*(i+1),2)]), ""), 1:5), "\n")

const solutiontext = ["Starting board:\n" * triangletext([0; ones(Int, 14)]) * "\n"]

function solve(mv, turns=1, bd=[0; ones(Int, 14)])
    if turns + 1 == length(bd)
        return true
    elseif bd[mv[2]] == 0 || (bd[mv[1]] == 0 && bd[mv[3]] == 0) || (bd[mv[3]] == 1 && bd[mv[1]] == 1)
        return false
    else
        movetext = "\nmove " * (bd[mv[1]] == 0 ? "$(mv[3]) to $(mv[1])" : "$(mv[1]) to $(mv[3])")
        newboard = deepcopy(bd)
        map(i -> newboard[i] = 1 - newboard[i], mv)
        for move in moves
            if solve(move, turns + 1, newboard)
                push!(solutiontext, (movetext * "\n" * triangletext(newboard) * "\n"))
                return true
            end
        end
    end
    false
end

for (i, move) in enumerate(moves)
    if solve(move)
        println(join([solutiontext[1]; reverse(solutiontext[2:end])], ""))
        break
    elseif i == length(moves)
        println("No solution found.")
    end
end
