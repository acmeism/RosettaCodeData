const winningpositions = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
    [2, 5, 8], [3, 6, 9],[1, 5, 9], [7, 5, 3]]

function haswon(brd, xoro)
    marked = findall(x -> x == xoro, brd)
    for pos in winningpositions
        if length(pos) <= length(marked) && pos == sort(marked)[1:3]
            return true
        end
    end
    false
end

function readcharwithprompt(prompt, expected)
    ret = '*'
    while !(ret in expected)
        print("\n", prompt, " ->  ")
        ret = lowercase(chomp(readline()))[1]
    end
    ret
end

availablemoves(brd) = findall(x -> x == ' ', brd)
cornersopen(brd) = [x for x in [1, 3, 7, 9] if brd[x] == ' ']
int2char(x) = Char(x + UInt8('0'))
char2int(x) = UInt8(x) - UInt8('0')
getyn(query) = readcharwithprompt(query, ['y', 'n'])
gettheirmove(brd) = char2int(readcharwithprompt("Your move(1-9)", int2char.(availablemoves(brd))))

function findwin(brd, xoro)
    tmpbrd = deepcopy(brd)
    for mv in availablemoves(tmpbrd)
        tmpbrd[mv] = xoro
        if haswon(tmpbrd, xoro)
            return mv
        end
        tmpbrd[mv] = ' '
    end
    return nothing
end

function choosemove(brd, mychar, theirchar)
    if all(x -> x == ' ', brd)
        brd[rand(cornersopen(brd))] = mychar # corner trap if starting game
    elseif availablemoves(brd) == [] # no more moves
        println("Game is over. It was a draw.")
        exit(0)
    elseif (x = findwin(brd, mychar)) != nothing || (x = findwin(brd, theirchar)) != nothing
        brd[x] = mychar # win if possible, block their win otherwise if their win is possible
    elseif brd[5] == ' '
        brd[5] = mychar # take center if open and not doing corner trap
    elseif (corners = cornersopen(brd)) != []
        brd[rand(corners)] = mychar # choose a corner over a side middle move
    else
        brd[rand(availablemoves(brd))] = mychar # random otherwise
    end
end

function display(brd)
    println("+-----------+")
    println("| ", brd[1], " | ", brd[2], " | ", brd[3], " |")
    println("| ", brd[4], " | ", brd[5], " | ", brd[6], " |")
    println("| ", brd[7], " | ", brd[8], " | ", brd[9], " |")
    println("+-----------+")
end

function tictactoe()
    board = fill(' ', 9)
    println("Board move grid:\n 1 2 3\n 4 5 6\n 7 8 9")
    yn = getyn("Would you like to move first (y/n)?")
    if yn == 'y'
        mychar = 'O'
        theirchar = 'X'
        board[gettheirmove(board)] = theirchar
    else
        mychar = 'X'
        theirchar = 'O'
    end
    while true
        choosemove(board, mychar, theirchar)
        println("Computer has moved.")
        display(board)
        if haswon(board, mychar)
            println("Game over. Computer wins!")
            exit(0)
        elseif availablemoves(board) == []
            break
        end
        board[gettheirmove(board)] = theirchar
        println("Player has moved.")
        display(board)
        if haswon(board, theirchar)
            println("Game over. Player wins!")
            exit(0)
        elseif availablemoves(board) == []
            break
        end
    end
    println("Game over. It was a draw.")
end

tictactoe()
