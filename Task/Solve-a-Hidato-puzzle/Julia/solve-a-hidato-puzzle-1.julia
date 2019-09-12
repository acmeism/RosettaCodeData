module Hidato

export hidatosolve, printboard, hidatoconfigure

function hidatoconfigure(str)
    lines = split(str, "\n")
    nrows, ncols = length(lines), length(split(lines[1], r"\s+"))
    board = fill(-1, (nrows, ncols))
    presets = Vector{Int}()
    starts = Vector{CartesianIndex{2}}()
    maxmoves = 0
    for (i, line) in enumerate(lines), (j, s) in enumerate(split(strip(line), r"\s+"))
        c = s[1]
        if c == '_' || (c == '0' && length(s) == 1)
            board[i, j] = 0
            maxmoves += 1
        elseif c == '.'
            continue
        else # numeral, get 2 digits
            board[i, j] = parse(Int, s)
            push!(presets, board[i, j])
            if board[i, j] == 1
                push!(starts, CartesianIndex(i, j))
            end
            maxmoves += 1
        end
    end
    board, maxmoves, sort!(presets), length(starts) == 1 ? starts : findall(x -> x == 0, board)
end

function hidatosolve(board, maxmoves, movematrix, fixed, row, col, sought)
    if sought > maxmoves
        return true
    elseif (0 != board[row, col] != sought) || (board[row, col] == 0 && sought in fixed)
        return false
    end
    backnum = board[row, col] == sought ? sought : 0
    board[row, col] = sought # try board with this cell set to next number
    for move in movematrix
        i, j = row + move[1], col + move[2]
        if (0 < i <= size(board)[1]) && (0 < j <= size(board)[2]) &&
            hidatosolve(board, maxmoves, movematrix, fixed, i, j, sought + 1)
            return true
        end
    end
    board[row, col] = backnum # return board to original state
    false
end

function printboard(board, emptysquare= "__ ", blocked = "   ")
    d = Dict(-1 => blocked, 0 => emptysquare, -2 => "\n")
    map(x -> d[x] = rpad(lpad(string(x), 2), 3), 1:maximum(board))
    println(join([d[i] for i in hcat(board, fill(-2, size(board)[1]))'], ""))
end

end  # module
