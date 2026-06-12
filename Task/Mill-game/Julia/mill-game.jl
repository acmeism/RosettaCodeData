"""
    Gtk4 GUI implementation of the Mill game (aka Nine Men's Morris)
    Derived in part from the FreeBASIC ASCII version (rosettacode.org/wiki/Mill_game#FreeBASIC)
    Rules:
    - Two players (WHITE and BLACK) take turns placing pieces on the board.
    - Each player has 9 pieces to place in the first part of the game.
    - Once all pieces are placed, players move existing pieces to adjacent empty spots.
    - Forming a mill (3 pieces in a row) allows the player to capture one of the opponent's pieces.
    - A player wins by reducing the opponent to 2 pieces or blocking all their moves.
"""

using Cairo
using Gtk4

const EMPTY = 0
const WHITE = 1
const BLACK = 2
const BOARD = fill(EMPTY, 24)
const MILLS = [
    (1, 2, 3), (4, 5, 6), (7, 8, 9), (10, 11, 12),
    (13, 14, 15), (16, 17, 18), (19, 20, 21), (22, 23, 24),
    (1, 10, 22), (4, 11, 19), (7, 12, 16), (2, 5, 8),
    (17, 20, 23), (9, 13, 18), (6, 14, 21), (3, 15, 24),
]
const ADJ = [
    [2, 10], [1, 3, 5], [2, 15],
    [5, 11], [2, 4, 6, 8], [5, 14],
    [8, 12], [5, 7, 9], [8, 13],
    [1, 11, 22], [4, 10, 12, 19], [7, 11, 16],
    [9, 14, 18], [6, 13, 15, 21], [3, 14, 24],
    [12, 17], [16, 18, 20], [13, 17],
    [11, 20], [17, 19, 21, 23], [14, 20],
    [10, 23], [20, 22, 24], [15, 23],
]

# Game state variables are stored as references for mutability in signal handlers
const WHITE_IN_HAND = Ref(9)
const BLACK_IN_HAND = Ref(9)
const TURN = Ref(WHITE)
const SELECTED = Ref(-1)
const CHOOSING_CAPTURE = Ref(false)
const WINNER = Ref(0)
const GAME_OVER = Ref(false)
const SKILLED = Ref(false)
const COMPUTER_OPPONENT = Ref(false)
const COMPUTER_WHITE = Ref(false)

# Precomputed board coordinates for Gtk drawing, indexed by board position 1-24
const COORDS = [
    (50, 50), (350, 50), (650, 50),
    (150, 150), (350, 150), (550, 150),
    (250, 250), (350, 250), (450, 250),
    (50, 350), (150, 350), (250, 350),
    (450, 350), (550, 350), (650, 350),
    (250, 450), (350, 450), (450, 450),
    (150, 550), (350, 550), (550, 550),
    (50, 650), (350, 650), (650, 650),
]

""" Return a list of valid move 2-tuples for player, used by computer opponent """
function validmoves(player)
    moves = Tuple{Int, Int}[]
    if inplacementphase()
        for i in 1:24
            if BOARD[i] == EMPTY
                push!(moves, (0, i))
            end
        end
    else
        for i in 1:24
            if BOARD[i] == player
                if countpieces(player) == 3
                    for j in 1:24
                        if BOARD[j] == EMPTY
                            push!(moves, (i, j))
                        end
                    end
                else
                    for j in ADJ[i]
                        if BOARD[j] == EMPTY
                            push!(moves, (i, j))
                        end
                    end
                end
            end
        end
    end
    return moves
end

""" Check if a position is part of player's mills """
function ispartofmill(pos, player)
    for m in MILLS
        if pos in m && all(BOARD[i] == player for i in m)
            return true
        end
    end
    return false
end

""" Check if placing/moving to pos creates a mill for player """
function createsmill(pos, player)
    for m in MILLS
        if pos in m && BOARD[pos] == EMPTY
            if all(i == pos || BOARD[i] == player for i in m)
                return true
            end
        end
    end
    return false
end

""" Check if pos is part of a full mill for player """
ismill(pos, player) = any(m -> pos in m && all(i == pos || BOARD[i] == player for i in m), MILLS)

"""
    Check if pos is part of a mill containing exactly one other piece which is
    also player's piece, used for computer capture logic to prioritize breaking
    up opponent's potential mills by blocking the third piece in the mill
"""
function ispartofpair(pos, player)
    for m in MILLS
        if pos in m
            pieces = [i for i in m if BOARD[i] == player]
            if length(pieces) == 2 && pos in pieces
                return true
            end
        end
    end
    return false
end

""" Check if all of player's pieces are in mills (used for capture rules) """
function allinmills(player)
    for i in 1:24
        if BOARD[i] == player
            if !any(i in m && all(j == i || BOARD[j] == player for j in m) for m in MILLS)
                return false
            end
        end
    end
    return true
end

""" Check if removing opponent's piece at pos is valid (not in a mill unless all are in mills) """
function validcapture(enemy, pos)
    BOARD[pos] != enemy && return false
    allinmills(enemy) && return true
    for m in MILLS
        if pos in m && all(i == pos || BOARD[i] == enemy for i in m)
            return false
        end
    end
    return true
end

""" Return a list of positions where (computer) player can move to form a mill on next turn """
function millmoves(player)
    moves = Tuple{Int, Int}[]
    for move in validmoves(player)
        if createsmill(move[end], player)
            push!(moves, move)
        end
    end
    return moves
end

""" Count how many pieces player has on the board """
countpieces(player) = count(==(player), BOARD)

""" True if we are still in the placement phase (for either, or for specified player) """
inplacementphase() = WHITE_IN_HAND[] > 0 || BLACK_IN_HAND[] > 0
inplacementphase(player) = player == WHITE ? (WHITE_IN_HAND[] > 0) : (BLACK_IN_HAND[] > 0)

""" Check if player has any valid moves left """
function canmove(player)
    pcount = countpieces(player)
    pcount == 3 && return any(BOARD .== EMPTY)
    for i in 1:24
        if BOARD[i] == player
            for j in ADJ[i]
                BOARD[j] == EMPTY && return true
            end
        end
    end
    return false
end

""" Handle capturing an opponent's piece after forming a mill, and check for win conditions """
function capture(enemy, pos = -1)
    if pos != -1
        BOARD[pos] = EMPTY
    else
        for i in 1:24
            if BOARD[i] == enemy
                BOARD[i] = EMPTY
                break
            end
        end
    end
    draw(canvas)
    show(win)
end

""" Check if it's currently the computer's turn to move, based on game settings and current turn """
function computersturn()::Bool
    return COMPUTER_OPPONENT[] &&
           ((COMPUTER_WHITE[] && TURN[] == WHITE) || (!COMPUTER_WHITE[] && TURN[] == BLACK))
end

""" Helper function to convert player constant to string for display purposes """
pcolor(player = TURN[]) = player == WHITE ? "WHITE" : "BLACK"

""" Check if game is over due to a win condition. Update state and display accordingly
    Returns true if game is over, false otherwise
"""
function checkisgameover()
    GAME_OVER[] && return true
    WINNER[] != 0 && return true
    # check if a piece is currently selected or in capture phase or placement phase
    (SELECTED[] != -1 || CHOOSING_CAPTURE[] || inplacementphase(TURN[])) && return false
    if countpieces(WHITE) < 3 || countpieces(BLACK) < 3 || !canmove(TURN[])
        WINNER[] = 3 - TURN[]
        winner = WINNER[] == WHITE ? "WHITE" : "BLACK"
        println("Game over. $winner wins.")
        GAME_OVER[] = true
        info_label.label = "Game over: $winner wins!"
        @async info_dialog("Game over: $winner wins!", win)
        show(win)
        show(info_label)
        return true
    end
    return false
end

"""
    Computer player capture logic:
    prioritize capturing pieces in pairs that might become mills,
    then pieces not in mills, otherwise random valid capture
"""
function computerchoosecapture(enemy)
    allinmills(enemy) && return rand(filter(i -> BOARD[i] == enemy, 1:24))
    cancapture = filter(i -> BOARD[i] == enemy && !ispartofmill(i, enemy), 1:24)
    inpairs = filter(i -> BOARD[i] == enemy && ispartofpair(i, enemy), cancapture)
    choosecapture = !isempty(inpairs) ? inpairs : cancapture
    return rand(choosecapture)
end

"""
    Computer player logic: unskilled choices are random valid moves, and more
    skilled prioritize forming mills, then blocking opponent, otherwise random valid move
"""
function computermove(player)
    checkisgameover() && return
    moves = validmoves(player)
    if SKILLED[]
        # form a mill if possible
        millforming = millmoves(player)
        if !isempty(millforming)
            moves = millforming
        else
            # try to block opponent's mill by moving a piece into the mill
            opponent = 3 - player
            opponentmills = millmoves(opponent)
            if !isempty(opponentmills)
                blockingmoves = Tuple{Int, Int}[]
                for move in opponentmills
                    if length(move) == 2 && (move[1] == 0 || BOARD[move[1]] == player)
                        push!(blockingmoves, move)
                    end
                end
                moves = !isempty(blockingmoves) ? blockingmoves : moves
            end
        end
    end
    if !isempty(moves)
        move = rand(moves)
        if move[1] == 0 # placement move
            BOARD[move[2]] = player
            if player == WHITE
                WHITE_IN_HAND[] -= 1
            else
                BLACK_IN_HAND[] -= 1
            end
            if ismill(move[2], player)
                info_label.label = "Computer formed a mill! This captures a $(pcolor(3 - player)) opponent piece."
                if SKILLED[]
                    pos = computerchoosecapture(3 - player)
                    capture(3 - player, pos)
                else
                    capture(3 - player)
                end
            end
        else # computer move piece from move[1] to move[2]
            BOARD[move[1]] = EMPTY
            BOARD[move[2]] = player
            if ismill(move[2], player)
                info_label.label = "Computer formed a mill! This captures a $(pcolor(3 - player)) opponent piece."
                if SKILLED[]
                    pos = computerchoosecapture(3 - player)
                    capture(3 - player, pos)
                else
                    capture(3 - player)
                end
            end
        end
    end
    TURN[] = 3 - player
    draw(canvas)
    show(win)
    checkisgameover()
end

# Define win and canvas as they are referenced in subsequent functions
const win = GtkWindow("Mill Game for Rosetta Code", 700, 780)
const hbox = GtkBox(:v)  # :h makes a horizontal layout, :v a vertical layout
push!(win, hbox)
const canvas = GtkCanvas(700, 720)
push!(hbox, canvas)
const info_label = GtkLabel("WHITE in hand: 9 | BLACK in hand: 9 | Turn: WHITE")
push!(hbox, info_label)

# Draw the game board and pieces on the canvas, called after state change to update display
@guarded draw(canvas) do widget
    ctx = Gtk4.getgc(widget)
    # fill background
    set_source_rgb(ctx, 0.97, 0.92, 0.8)
    paint(ctx)
    set_source_rgb(ctx, 0, 0, 0)
    set_line_width(ctx, 2)
    # draw board lines
    for (a, b, c) in MILLS[1:16]
        move_to(ctx, COORDS[a]...)
        line_to(ctx, COORDS[b]...)
        line_to(ctx, COORDS[c]...)
        stroke(ctx)
        move_to(ctx, COORDS[a]...)
        arc(ctx, COORDS[a]..., 3, 0, 2pi)
        fill(ctx)
        move_to(ctx, COORDS[b]...)
        arc(ctx, COORDS[b]..., 3, 0, 2pi)
        fill(ctx)
        move_to(ctx, COORDS[c]...)
        arc(ctx, COORDS[c]..., 3, 0, 2pi)
        fill(ctx)
    end
    # draw existing pieces
    for (i, piece) in enumerate(BOARD)
        iszero(piece) && continue
        x, y = COORDS[i]
        set_source_rgb(ctx, 0, 0, 0)
        arc(ctx, x, y, 25, 0, 2pi)
        stroke(ctx)
        if piece == WHITE
            set_source_rgb(ctx, 0.94, 0.96, 0.98)
        else
            set_source_rgb(ctx, 0.1, 0.1, 0.1)
        end
        arc(ctx, x, y, 23, 0, 2pi)
        fill(ctx)
        # highlight a piece that is being moved in the movement phase
        if SELECTED[] == i
            set_source_rgb(ctx, 1, 0, 0)
            arc(ctx, x, y, 28, 0, 2pi)
            stroke(ctx)
        end
    end
end

""" Find mouse click input position on board, returns -1 if not on a valid position """
function findposition(x, y)
    for i in 1:24
        px, py = COORDS[i]
        if hypot(px-x, py-y) < 25
            return i
        end
    end
    return -1
end

""" Handle mouse clicks for placing/moving pieces, capturing, and detecting win conditions """
function onpressed(controller, npress, x, y)
    computersturn() && return
    GAME_OVER[] && return
    checkisgameover() && return
    pos = findposition(x, y)
    pos == -1 && return
    player = TURN[]
    if CHOOSING_CAPTURE[] # first check if player is selecting a capture
        enemy = 3 - player
        if validcapture(enemy, pos)
            capture(enemy, pos)
            CHOOSING_CAPTURE[] = false
            TURN[] = 3 - player
            info_label.label = "Captured opponent piece. Turn: $(pcolor())"
        else
            info_label.label = "Invalid capture. Please select a valid opponent piece to capture. Turn: $(pcolor())"
        end
    elseif inplacementphase(player) # placement phase
        if BOARD[pos] == EMPTY
            BOARD[pos] = player
            if player == WHITE
                WHITE_IN_HAND[] -= 1
            else
                BLACK_IN_HAND[] -= 1
            end
            if ismill(pos, player)
                CHOOSING_CAPTURE[] = true
                info_label.label = "Mill formed! Please select an opponent piece to capture. Turn: $(pcolor())"
            else
                TURN[] = 3 - player
                if !inplacementphase()
                    info_label.label = "All pieces placed. Movement phase begins. Turn: $(pcolor())"
                else
                    info_label.label = "WHITE in hand: $(WHITE_IN_HAND[]) | BLACK in hand: $(BLACK_IN_HAND[]) | Turn: $(pcolor())"
                end
            end
        end
    else # movement phase
        if SELECTED[] == -1
            if BOARD[pos] == player && (any(BOARD[adj] == EMPTY for adj in ADJ[pos]) || countpieces(player) == 3)
                SELECTED[] = pos
            end
            info_label.label = "In movement phase, piece being moved. Turn: $(pcolor())"
        else
            if BOARD[pos] == EMPTY && (pos in ADJ[SELECTED[]] || countpieces(player) == 3)
                BOARD[SELECTED[]] = EMPTY
                SELECTED[] = -1
                BOARD[pos] = player
                if ismill(pos, player)
                    CHOOSING_CAPTURE[] = true
                    info_label.label = "Mill formed! Please select an opponent piece to capture. Turn: $(pcolor())"
                else
                    TURN[] = 3 - player
                    checkisgameover() && return
                    info_label.label = "In movement phase. Turn: $(pcolor())"
                end
            else
                SELECTED[] = -1
                info_label.label = "Invalid move. Turn: $(pcolor())"
            end
        end
    end
    draw(canvas)
    show(win)
    checkisgameover()
end

# Mouse click dispatcher
const gclick = GtkGestureClick()
push!(canvas, gclick)
signal_connect(onpressed, gclick, "pressed")

# Run initial prompts for computer opponent and skill level
COMPUTER_OPPONENT[] =
    ask_dialog(
        "Computer to play one side?", win;
        no_text = "No, two human players", yes_text = "One versus Computer")
if COMPUTER_OPPONENT[]
    SKILLED[] = ask_dialog(
        "Computer opponent's skill level", win;
        no_text = "Easy", yes_text = "Somewhat harder")
    COMPUTER_WHITE[] = ask_dialog(
        "Computer plays as WHITE?", win;
        no_text = "No, computer is BLACK", yes_text = "Yes, computer is WHITE")
end
# Show the window and wait for end of game, moving as computer when needed
show(win)
show(canvas)
while !GAME_OVER[]
    if computersturn()
        computermove(TURN[])
        draw(canvas)
        show(win)
    end
    sleep(rand(0.5:0.1:2.5)) # small random delay for player simulation
end
