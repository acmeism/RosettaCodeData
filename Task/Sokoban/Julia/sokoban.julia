struct BoardState
    board::String
    csol::String
    position::Int
end

function move(s::BoardState, dpos)
    buffer = Vector{UInt8}(deepcopy(s.board))
    if s.board[s.position] == '@'
        buffer[s.position] = ' '
    else
        buffer[s.position] = '.'
    end
    newpos = s.position + dpos
    if s.board[newpos] == ' '
        buffer[newpos] = '@'
    else
        buffer[newpos] = '+'
    end
    String(buffer)
end

function push(s::BoardState, dpos)
    newpos = s.position + dpos
    boxpos = newpos + dpos
    if s.board[boxpos] != ' ' && s.board[boxpos] != '.'
        return ""
    end
    buffer = Vector{UInt8}(deepcopy(s.board))
    if s.board[s.position] == '@'
        buffer[s.position] = ' '
    else
        buffer[s.position] = '.'
    end
    if s.board[newpos] == '$'
        buffer[newpos] = '@'
    else
        buffer[newpos] = '+'
    end
    if s.board[boxpos] == ' '
        buffer[boxpos] = '$'
    else
        buffer[boxpos] = '*'
    end
    String(buffer)
end

function solve(board)
    width = findfirst("\n", board[2:end])[1] + 1
    dopt = (u = -width, l = -1, d = width, r = 1)
    visited = Dict(board => true)
    open::Vector{BoardState} = [BoardState(board, "", findfirst("@", board)[1])]
    while length(open) > 0
        s1 = open[1]
        open = open[2:end]
        for dir in keys(dopt)
            newpos = s1.position + dopt[dir]
            x = s1.board[newpos]
            if x == '$' || x == '*'
                newboard = push(s1, dopt[dir])
                if newboard == "" || haskey(visited, newboard)
                    continue
                end
                newsol = s1.csol * uppercase(string(dir))
                if findfirst(r"[\.\+]", newboard) ==  nothing
                    return newsol
                end
            elseif x == ' ' || x == '.'
                newboard = move(s1, dopt[dir])
                if haskey(visited, newboard)
                    continue
                end
                newsol = s1.csol * string(dir)
            else
                continue
            end
            open = push!(open, BoardState(newboard, newsol, newpos))
            visited[newboard] = true
        end
    end
    "No solution" # we should only get here if no solution to the sokoban
end

const testlevel = strip(raw"""
#######
#     #
#     #
#. #  #
#. $$ #
#.$$  #
#.#  @#
#######""")
println("For sokoban level:\n$testlevel\n...solution is :\n$(solve(testlevel))")
