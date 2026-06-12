""" Chess moves """

""" Chess Piece struct. type: Char ('P', 'R', 'N', 'B', 'Q', 'K') color: 'w', 'b' """
struct Piece
    type::Char
    color::Char
end
Base.print(io::IO, p::Piece) = print(io, p.color == 'w' ? p.type : lowercase(p.type))

""" Chess Board is 8 x 8 Matrix """
struct Board
    squares::Matrix{Union{Piece, Nothing}}
    turn::Char # 'w' or 'b'
    castlingrights::String # starts as "KQkq", kingside queenside for white, black
    enpassant::Tuple{Int, Int} # position of a pawn that can be captured en passant, (0, 0) if none
    halfmoveclock::Int # for fifty-move rule
    fullmoveclock::Int # running total of full moves
end

""" Chess Move struct, 1-based, defined by the movement not the Piece moved """
struct Move
    start_row::Int
    start_col::Int
    end_row::Int
    end_col::Int
    piece::Union{Piece, Nothing} # for pawn promotion
    function Move(start_row::Int, start_col::Int, end_row::Int, end_col::Int, piece::Union{Piece, Nothing} = nothing)
        new(start_row, start_col, end_row, end_col, piece)
    end
end

""" Convert (row, col) 1-based position to algebraic notation (e.g., "a1") """
function algebraic(row::Int, col::Int, piece::Union{Piece, Nothing} = nothing)::String
    file = Char('a' + (col - 1))  # columns are 1 to 8, map to 'a' to 'h'
    rank = Char('8' - (row - 1))  # rows are 1 to 8, map to '8' to '1'
    # Handle pawn promotion
    if piece !== nothing && piece.type == 'P' && (row == 1 || row == 8)
        return string(file, rank, "=", piece.type)
    end
    return string(file, rank)
end

""" Convert a Move to algebraic notation (e.g., "e2e4") """
function Base.print(io::IO, m::Move)
    print(io, "$(algebraic(m.start_row, m.start_col, m.piece))$(algebraic(m.end_row, m.end_col, m.piece))")
end

""" Convert algebraic notation to a Tuple{Int, Int}. """
function algebraic2tuple(alg::AbstractString)::Tuple{Int, Int}
    length(alg) != 2 && return (0, 0) # "-" or invalid input
    file = alg[1]
    rank = alg[2]
    col = Int(file - 'a') + 1  # 'a' maps to 1, 'h' to 8
    row = Int('8' - rank) + 1  # '8' maps to 1, '1' to 8
    return (row, col)
end

""" Parses a FEN string. Returns a Board set per FEN """
function parseFEN(fen_string::String)::Board
    parts = split(fen_string, ' ')
    boardstr = parts[1]
    turnchar = parts[2][1]
    castlingrights = parts[3]
    enpassant = algebraic2tuple(parts[4])
    halfmove = parse(Int, parts[5])
    fullmove = parse(Int, parts[6])

    squares = Matrix{Union{Piece, Nothing}}(undef, 8, 8)
    row, col = 1, 1
    for char in boardstr
        if char == '/'
            row += 1
            col = 1
        elseif isdigit(char)
            num_empty = parse(Int, char)
            for _ in 1:num_empty
                squares[row, col] = nothing
                col += 1
            end
        else
            color = isuppercase(char) ? 'w' : 'b'
            piece_type = uppercase(char)
            squares[row, col] = Piece(piece_type, color)
            col += 1
        end
    end
    return Board(squares, turnchar, castlingrights, enpassant, halfmove, fullmove)
end

""" Prints an ASCII visual representation of the chess board to stdout """
function Base.print(io::IO, board::Board)
    println(io, "  a b c d e f g h")
    println(io, " +-----------------+")
    for r in 1:8
        print(io, "$(9 - r)|")
        for c in 1:8
            piece = board.squares[r, c]
            if piece === nothing
                print(io, " .")
            else
                print(io, " $piece")
            end
        end
        println(io, " |$(9 - r)")
    end
    println(io, " +-----------------+")
    println(io, "  a b c d e f g h")
    println(io, "Current turn: $(board.turn == 'w' ? "White" : "Black")")
    println(io, "Castling rights: $(board.castlingrights)")
end

""" Checks if the given row and column are within the 8x8 board boundaries (1-indexed). """
@inline isvalidsquare(row::Int, col::Int)::Bool = 1 <= row <= 8 && 1 <= col <= 8

""" Returns the piece at the 1-based (row, col) on the board, or nothing if empty. """
piece_at(brd::Board, row, col)::Union{Piece, Nothing} = brd.squares[row, col]

""" Applies a move to a new (cloned) board state and returns the new Board. """
function move!(board::Board, move::Move)::Board
    new_squares = deepcopy(board.squares)
    moving_piece = piece_at(board, move.start_row, move.start_col)
    moving_piece === nothing && return board # sanity check

    # Handle castling
    if moving_piece.type == 'K' && abs(move.start_col - move.end_col) == 2
        king_row = move.start_row
        if move.end_col == 7 # kingside castling
            new_squares[king_row, 7] = moving_piece
            new_squares[king_row, move.start_col] = nothing
            rook = piece_at(board, king_row, 8)
            new_squares[king_row, 6] = rook
            new_squares[king_row, 8] = nothing
        elseif move.end_col == 3 # queenside castling
            new_squares[king_row, 3] = moving_piece
            new_squares[king_row, move.start_col] = nothing
            rook = piece_at(board, king_row, 1)
            new_squares[king_row, 4] = rook
            new_squares[king_row, 1] = nothing
        end
    elseif moving_piece.type == 'P' # handle special en passant pawn moves
        if move.end_col != move.start_col && piece_at(board, move.end_row, move.end_col) isa Nothing
            target_row = move.end_row + (moving_piece.color == 'w' ? 1 : -1)
            captured_piece = piece_at(board, target_row, move.end_col)
            if captured_piece !== nothing && captured_piece.type == 'P' && captured_piece.color != moving_piece.color
                new_squares[target_row, move.end_col] = nothing
                new_squares[move.end_row, move.end_col] = moving_piece
                new_squares[move.start_row, move.start_col] = nothing
            end
        end
    else
        # Handle all other moves
        new_squares[move.end_row, move.end_col] = moving_piece
        new_squares[move.start_row, move.start_col] = nothing
    end

    # Update castling rights
    new_castling_rights = board.castlingrights
    if moving_piece.type == 'K'
        if moving_piece.color == 'w'
            new_castling_rights = replace(new_castling_rights, 'K' => "", 'Q' => "")
        else
            new_castling_rights = replace(new_castling_rights, 'k' => "", 'q' => "")
        end
    elseif moving_piece.type == 'R'
        if moving_piece.color == 'w'
            if move.start_row == 8 && move.start_col == 8
                new_castling_rights = replace(new_castling_rights, 'K' => "")
            elseif move.start_row == 8 && move.start_col == 1
                new_castling_rights = replace(new_castling_rights, 'Q' => "")
            end
        else
            if move.start_row == 1 && move.start_col == 8
                new_castling_rights = replace(new_castling_rights, 'k' => "")
            elseif move.start_row == 1 && move.start_col == 1
                new_castling_rights = replace(new_castling_rights, 'q' => "")
            end
        end
    end

    captured_piece_at_dest = piece_at(board, move.end_row, move.end_col)
    if captured_piece_at_dest !== nothing && captured_piece_at_dest.type == 'R'
        if captured_piece_at_dest.color == 'w'
            if move.end_row == 8 && move.end_col == 8
                new_castling_rights = replace(new_castling_rights, 'K' => "")
            elseif move.end_row == 8 && move.end_col == 1
                new_castling_rights = replace(new_castling_rights, 'Q' => "")
            end
        else
            if move.end_row == 1 && move.end_col == 8
                new_castling_rights = replace(new_castling_rights, 'k' => "")
            elseif move.end_row == 1 && move.end_col == 1
                new_castling_rights = replace(new_castling_rights, 'q' => "")
            end
        end
    end

    if isempty(new_castling_rights)
        new_castling_rights = "-"
    end

    # Handle en passant
    new_enpassant = (0, 0)
    if moving_piece.type == 'P' && abs(move.start_row - move.end_row) == 2
        new_enpassant = (move.end_row + (moving_piece.color == 'w' ? 1 : -1), move.end_col)
    else
        new_enpassant = board.enpassant
    end

    new_turn = (board.turn == 'w' ? 'b' : 'w')
    return Board(new_squares, new_turn, new_castling_rights, new_enpassant,
                 board.halfmoveclock + 1, board.fullmoveclock + (new_turn == 'b' ? 1 : 0))
end

""" Finds the 1-based (row, col) of the king of the specified color on the board. """
function findking(board::Board, king_color::Char)::Union{Tuple{Int, Int}, Nothing}
    for r in 1:8
        for c in 1:8
            piece = piece_at(board, r, c)
            if piece !== nothing && piece.type == 'K' && piece.color == king_color
                return (r, c)
            end
        end
    end
    return nothing
end

""" Checks if a given square (row, col) is attacked by any piece of attacking_color """
function issquareattacked(board::Board, row::Int, col::Int, attacking_color::Char)::Bool
    opponent_color = attacking_color
    pawn_dir = (opponent_color == 'w' ? -1 : 1)
    for dc in [-1, 1]
        target_row, target_col = row + pawn_dir, col + dc
        if isvalidsquare(target_row, target_col)
            piece = piece_at(board, target_row, target_col)
            if piece !== nothing && piece.color == opponent_color && piece.type == 'P'
                return true
            end
        end
    end

    knight_moves = [(-2, -1), (-2, 1), (-1, -2), (-1, 2), (1, -2), (1, 2), (2, -1), (2, 1)]
    for (dr, dc) in knight_moves
        target_row, target_col = row + dr, col + dc
        if isvalidsquare(target_row, target_col)
            piece = piece_at(board, target_row, target_col)
            if piece !== nothing && piece.color == opponent_color && piece.type == 'N'
                return true
            end
        end
    end

    straight_dirs = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    for (dr, dc) in straight_dirs
        for i in 1:7
            target_row, target_col = row + i * dr, col + i * dc
            if !isvalidsquare(target_row, target_col)
                break
            end
            piece = piece_at(board, target_row, target_col)
            if piece !== nothing
                if piece.color == opponent_color && (piece.type == 'R' || piece.type == 'Q')
                    return true
                else
                    break
                end
            end
        end
    end

    diagonal_dirs = [(1, 1), (1, -1), (-1, 1), (-1, -1)]
    for (dr, dc) in diagonal_dirs
        for i in 1:7
            target_row, target_col = row + i * dr, col + i * dc
            if !isvalidsquare(target_row, target_col)
                break
            end
            piece = piece_at(board, target_row, target_col)
            if piece !== nothing
                if piece.color == opponent_color && (piece.type == 'B' || piece.type == 'Q')
                    return true
                else
                    break
                end
            end
        end
    end

    king_moves = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
    for (dr, dc) in king_moves
        target_row, target_col = row + dr, col + dc
        if isvalidsquare(target_row, target_col)
            piece = piece_at(board, target_row, target_col)
            if piece !== nothing && piece.color == opponent_color && piece.type == 'K'
                return true
            end
        end
    end
    return false
end

""" True if the color king is currently in check on the given board. """
function incheck(board::Board, color::Char)::Bool
    king_pos = findking(board, color)
    if king_pos === nothing
        println("Warning: King of color $color not found on board.")
        return false
    end
    king_row, king_col = king_pos
    attacking_color = (color == 'w' ? 'b' : 'w')
    return issquareattacked(board, king_row, king_col, attacking_color)
end

""" Get legal moves for a pawn at (r, c). """
function pawnmoves(board::Board, r::Int, c::Int, piece::Piece)::Vector{Move}
    moves = Move[]
    direction = (piece.color == 'w' ? -1 : 1)
    start_rank = (piece.color == 'w' ? 7 : 2)

    target_row = r + direction
    if isvalidsquare(target_row, c) && piece_at(board, target_row, c) === nothing
        if target_row == 1 || target_row == 8 # Promotion row
            for promotion_piece in ['Q', 'R', 'B', 'N']
                push!(moves, Move(r, c, target_row, c, Piece(promotion_piece, piece.color)))
            end
        else
            push!(moves, Move(r, c, target_row, c))
            if r == start_rank
                double_target_row = r + 2 * direction
                if isvalidsquare(double_target_row, c) && piece_at(board, double_target_row, c) === nothing
                    push!(moves, Move(r, c, double_target_row, c))
                end
            end
        end
    end

    for dc in [-1, 1]
        target_row, target_col = r + direction, c + dc
        if isvalidsquare(target_row, target_col)
            target_piece = piece_at(board, target_row, target_col)
            if target_piece !== nothing && target_piece.color != piece.color ||
               board.enpassant == (target_row, target_col)
                push!(moves, Move(r, c, target_row, target_col))
            end
        end
    end
    return moves
end

""" Helper for Rook, Bishop, Queen, get moves in sliding order along given directions """
function getslidingmoves(board::Board, r::Int, c::Int, piece::Piece, directions::Vector{Tuple{Int, Int}})::Vector{Move}
    moves = Move[]
    for (dr, dc) in directions
        for i in 1:7
            target_row, target_col = r + i * dr, c + i * dc
            if !isvalidsquare(target_row, target_col)
                break
            end
            target_piece = piece_at(board, target_row, target_col)
            if target_piece === nothing
                push!(moves, Move(r, c, target_row, target_col))
            elseif target_piece.color != piece.color
                push!(moves, Move(r, c, target_row, target_col))
                break
            else
                break
            end
        end
    end
    return moves
end

""" Generate moves for a rook at (r, c). """
function rookmoves(board::Board, r::Int, c::Int, piece::Piece)::Vector{Move}
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    return getslidingmoves(board, r, c, piece, directions)
end

""" Generate moves for a bishop at (r, c). """
function bishopmoves(board::Board, r::Int, c::Int, piece::Piece)::Vector{Move}
    directions = [(1, 1), (1, -1), (-1, 1), (-1, -1)]
    return getslidingmoves(board, r, c, piece, directions)
end

""" Generate moves for a queen at (r, c). """
function queenmoves(board::Board, r::Int, c::Int, piece::Piece)::Vector{Move}
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]
    return getslidingmoves(board, r, c, piece, directions)
end

""" Generate moves for a knight at (r, c). """
function knightmoves(board::Board, r::Int, c::Int, piece::Piece)::Vector{Move}
    moves = Move[]
    knight_offsets = [(-2, -1), (-2, 1), (-1, -2), (-1, 2), (1, -2), (1, 2), (2, -1), (2, 1)]
    for (dr, dc) in knight_offsets
        target_row, target_col = r + dr, c + dc
        if isvalidsquare(target_row, target_col)
            target_piece = piece_at(board, target_row, target_col)
            if target_piece === nothing || target_piece.color != piece.color
                push!(moves, Move(r, c, target_row, target_col))
            end
        end
    end
    return moves
end

""" Generate moves for a king at (r, c) """
function kingmoves(board::Board, r::Int, c::Int, piece::Piece)::Vector{Move}
    moves = Move[]
    king_offsets = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
    for (dr, dc) in king_offsets
        target_row, target_col = r + dr, c + dc
        if isvalidsquare(target_row, target_col)
            target_piece = piece_at(board, target_row, target_col)
            if target_piece === nothing || target_piece.color != piece.color
                push!(moves, Move(r, c, target_row, target_col))
            end
        end
    end

    king_color = piece.color
    opponent_color = (king_color == 'w' ? 'b' : 'w')
    if incheck(board, king_color)
        return moves
    end
    initial_king_row = (king_color == 'w' ? 8 : 1)
    if !(r == initial_king_row && c == 5)
        return moves
    end

    if king_color == 'w' && 'K' in board.castlingrights
        if piece_at(board, initial_king_row, 6) === nothing && piece_at(board, initial_king_row, 7) === nothing
            rook = piece_at(board, initial_king_row, 8)
            if rook !== nothing && rook.type == 'R' && rook.color == king_color
                if !issquareattacked(board, initial_king_row, 5, opponent_color) &&
                   !issquareattacked(board, initial_king_row, 6, opponent_color) &&
                   !issquareattacked(board, initial_king_row, 7, opponent_color)
                    push!(moves, Move(r, c, initial_king_row, 7))
                end
            end
        end
    end

    if king_color == 'w' && 'Q' in board.castlingrights
        if piece_at(board, initial_king_row, 2) === nothing && piece_at(board, initial_king_row, 3) === nothing &&
           piece_at(board, initial_king_row, 4) === nothing
            rook = piece_at(board, initial_king_row, 1)
            if rook !== nothing && rook.type == 'R' && rook.color == king_color
                if !issquareattacked(board, initial_king_row, 5, opponent_color) &&
                   !issquareattacked(board, initial_king_row, 4, opponent_color) &&
                   !issquareattacked(board, initial_king_row, 3, opponent_color)
                    push!(moves, Move(r, c, initial_king_row, 3))
                end
            end
        end
    end

    if king_color == 'b' && 'k' in board.castlingrights
        if piece_at(board, initial_king_row, 6) === nothing && piece_at(board, initial_king_row, 7) === nothing
            rook = piece_at(board, initial_king_row, 8)
            if rook !== nothing && rook.type == 'R' && rook.color == king_color
                if !issquareattacked(board, initial_king_row, 5, opponent_color) &&
                   !issquareattacked(board, initial_king_row, 6, opponent_color) &&
                   !issquareattacked(board, initial_king_row, 7, opponent_color)
                    push!(moves, Move(r, c, initial_king_row, 7))
                end
            end
        end
    end

    if king_color == 'b' && 'q' in board.castlingrights
        if piece_at(board, initial_king_row, 2) === nothing && piece_at(board, initial_king_row, 3) === nothing &&
           piece_at(board, initial_king_row, 4) === nothing
            rook = piece_at(board, initial_king_row, 1)
            if rook !== nothing && rook.type == 'R' && rook.color == king_color
                if !issquareattacked(board, initial_king_row, 5, opponent_color) &&
                   !issquareattacked(board, initial_king_row, 4, opponent_color) &&
                   !issquareattacked(board, initial_king_row, 3, opponent_color)
                    push!(moves, Move(r, c, initial_king_row, 3))
                end
            end
        end
    end

    return moves
end

""" Gets all legal moves for the current player on the given board. """
function getlegalmoves(board::Board)::Vector{Move}
    allmoves = Move[]
    movingplayercolor = board.turn
    for r in 1:8
        for c in 1:8
            piece = piece_at(board, r, c)
            if piece !== nothing && piece.color == movingplayercolor
                if piece.type == 'P'
                    append!(allmoves, pawnmoves(board, r, c, piece))
                elseif piece.type == 'R'
                    append!(allmoves, rookmoves(board, r, c, piece))
                elseif piece.type == 'N'
                    append!(allmoves, knightmoves(board, r, c, piece))
                elseif piece.type == 'B'
                    append!(allmoves, bishopmoves(board, r, c, piece))
                elseif piece.type == 'Q'
                    append!(allmoves, queenmoves(board, r, c, piece))
                elseif piece.type == 'K'
                    append!(allmoves, kingmoves(board, r, c, piece))
                end
            end
        end
    end
    legal_moves = Move[]
    for mov in unique(allmoves)
        temp_board = move!(board, mov)
        if !incheck(temp_board, movingplayercolor)
            push!(legal_moves, mov)
        end
    end
    return legal_moves
end

""" Test various chess positions and legal moves """
function testchess()
    fen_start = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    board_start = parseFEN(fen_start)
    println("--- Starting Position ---")
    print(board_start)
    moves_start = getlegalmoves(board_start)
    println("\nLegal moves for White:")
    if isempty(moves_start)
        println("No legal moves.")
    else
        for mov in moves_start
            println("- $mov")
        end
    end
    println("Total legal moves: $(length(moves_start))")
    println("\n" * "="^40 * "\n")

    fen_check = "4k3/8/8/7Q/8/8/8/4K3 b - - 0 1"
    board_check = parseFEN(fen_check)
    println("--- Position with Black in Check ---")
    print(board_check)
    println("\nIs Black king in check? $(incheck(board_check, 'b'))")
    moves_check = getlegalmoves(board_check)
    println("\nLegal moves for Black (to get out of check or make other moves):")
    if isempty(moves_check)
        println("No legal moves. (This might indicate checkmate or stalemate)")
    else
        for mov in moves_check
            println("- $mov")
        end
    end
    println("Total legal moves: $(length(moves_check))")
    println("\n" * "="^40 * "\n")

    fen_midgame = "r3k2r/p1ppqpb1/bn2pn1p/3PP1p1/1p2P3/2N2N2/PPPBBPPP/R2QK2R w KQkq - 0 1"
    board_midgame = parseFEN(fen_midgame)
    println("--- Mid-game Position (White to move) ---")
    print(board_midgame)
    moves_midgame = getlegalmoves(board_midgame)
    println("\nLegal moves for White:")
    if isempty(moves_midgame)
        println("No legal moves.")
    else
        for mov in moves_midgame
            println("- $mov")
        end
    end
    println("Total legal moves: $(length(moves_midgame))")
    println("\n" * "="^40 * "\n")

    fen_castling_white = "r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1"
    board_castling_white = parseFEN(fen_castling_white)
    println("--- Position Allowing White Castling ---")
    print(board_castling_white)
    moves_castling_white = getlegalmoves(board_castling_white)
    println("\nLegal moves for White (including castling):")
    if isempty(moves_castling_white)
        println("No legal moves.")
    else
        for mov in moves_castling_white
            println("- $mov")
        end
    end
    println("Total legal moves: $(length(moves_castling_white))")
    println("\n" * "="^40 * "\n")

    fen_promotion = "8/4P2k/8/8/8/8/8/R3K2R w KQkq - 0 1"
    board_promotion = parseFEN(fen_promotion)
    println("--- Position Allowing Pawn Promotion ---")
    print(board_promotion)
    moves_promotion = getlegalmoves(board_promotion)
    println("\nLegal moves for White (including pawn promotions):")
    if isempty(moves_promotion)
        println("No legal moves.")
    else
        for mov in moves_promotion
            println("- $mov")
        end
    end
    println("Total legal moves: $(length(moves_promotion))")
    println("\n" * "="^40 * "\n")

    fen_enpassant = "rnbqkbnr/ppp1p1pp/8/3pPp2/8/8/PPPP1PPP/RNBQKBNR w KQkq f6 0 3"
    board_enpassant = parseFEN(fen_enpassant)
    println("--- Position Allowing En Passant ---")
    print(board_enpassant)
    moves_including_enpassant = getlegalmoves(board_enpassant)
    println("\nLegal moves for White (including en passant capture):")
    if isempty(moves_including_enpassant)
        println("No legal moves.")
    else
        for mov in moves_including_enpassant
            println("- $mov")
        end
    end
    println("Total legal moves: $(length(moves_including_enpassant))")
    println("\n" * "="^40 * "\n")

    fen_stalemate = "8/8/8/8/8/6k1/5b2/7K w - - 12 95"
    board_stalemate = parseFEN(fen_stalemate)
    println("--- Stalemate Position ---")
    print(board_stalemate)
    moves_stalemate = getlegalmoves(board_stalemate)
    println("\nLegal moves for White (should be none):")
    if isempty(moves_stalemate)
        println("No legal moves. (This indicates stalemate)")
    else
        for mov in moves_stalemate
            println("- $mov")
        end
    end
    println("Total legal moves: $(length(moves_stalemate))")
    println("\n" * "="^40 * "\n")
end

# Run the main test function
testchess()
