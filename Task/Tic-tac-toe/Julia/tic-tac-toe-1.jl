# The state of the game is represented as a vector of moves made so far
const TTT = Vector{Int}

@enum Role N X O      # N = 0, neither X nor O
role(turn::Int) = isodd(turn) ? X : O

# game state functions:
next_role(moves::TTT) = role(length(moves)+1)
available(moves::TTT) = setdiff(1:9, moves)
function winner(moves::TTT)
    wintriples = [
        [1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
        [1, 4, 7], [2, 5, 8], [3, 6, 9], # columns
        [1, 5, 9], [3, 5, 7] ]           # diagonals
    turn = length(moves); XorO = role(turn)
    inmoves(triple) = all(∈(moves[Int(XorO):2:end]), triple)
    turn ≥ 5 && any(inmoves, wintriples) && return XorO
    N
end

# scoring a state of the game with the recursive negamax algorithm
negamax(moves::TTT) = winner(moves) ≠ N ? 1 : length(moves) == 9 ? 0 :
    -maximum(negamax([moves; move]) for move ∈ available(moves))

scored_options(moves::TTT) =
    Dict(move => negamax([moves; move]) for move ∈ available(moves))

# players of X and O with different intelligence
abstract type Player end

struct RandomBot <: Player end
select_move(::RandomBot, moves::TTT) = rand(available(moves))

struct NegamaxBot <: Player end
function select_move(::NegamaxBot, moves::TTT)
    opts = scored_options(moves)
    maxscore = maximum(values(opts))
    rand([move for (move, score) ∈ opts if score == maxscore])
end

struct Human <: Player name::String end
function select_move(player::Human, moves::TTT)
    move = 0
    while move ∉ available(moves)
        print(player, " as ", next_role(moves), ", enter your move: ")
        move = try parse(Int, readline()) catch; 0 end
    end
    move
end

Base.show(io::IO, player::Player) =
    print(io, player isa Human ? player.name : typeof(player))

function displayboard(moves::TTT, hints = false)
    reset = "\e[0m"; bold = reset * "\e[1m"; faint = reset * "\e[2m"
    board = fill(" ", 9)
    fillmove((i, move)) = board[move] = bold * repr(role(i)) * faint
    foreach(fillmove, enumerate(moves))
    fillscore((move, score)) =
        board[move] = isone(score) ? "+" : iszero(score) ? "·" : "-"
    hints && foreach(fillscore, scored_options(moves))
    matrix = reshape([n*m for (n, m) in zip("¹²³⁴⁵⁶⁷⁸⁹", board)], 3, 3)
    to_row(col) = join(col, " │")
    rows = join(to_row.(eachcol(matrix)), "\n───┼───┼───\n")
    println(faint, "   ╷   ╷\n", rows, "\n   ╵   ╵", reset)
end

function ttt(Xplayer::Player, Oplayer::Player; hints = true)
    moves = TTT(); cast = Dict(X => Xplayer, O => Oplayer)
    println("\n","-"^40,"\nLet's play TicTacToe")
    println("Cast: X => $Xplayer, O => $Oplayer\n", "-"^40)
    while winner(moves) == N && length(moves) < 9
        displayboard(moves, hints)
        XorO = next_role(moves)
        player = cast[XorO]
        move = select_move(player, moves)
        player isa Human ||
            println(player, " as ", XorO, " plays move: ", move)
        push!(moves, move)
    end
    displayboard(moves)
    XorO = winner(moves)
    println( XorO == N ? "It's a draw!" :
        cast[XorO] isa Human ? "Congratulations, $(cast[XorO])! You win!" :
            "$player as $XorO wins!" )
end

ttt(RandomBot(), NegamaxBot(); hints = false)
ttt(RandomBot(), Human("Alice"))
