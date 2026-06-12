#!/usr/bin/env python3
import sys

black_pawn = " \u265f  "
white_pawn = " \u2659  "
empty_square = "    "


def draw_board(board_data):
    #bg_black = "\u001b[40m"
    bg_black = "\u001b[48;5;237m"
    #bg_white = "\u001b[47m"
    bg_white = "\u001b[48;5;245m"

    clear_to_eol = "\u001b[0m\u001b[K\n"

    board = ["1 ", bg_black, board_data[0][0], bg_white, board_data[0][1], bg_black, board_data[0][2], clear_to_eol,
             "2 ", bg_white, board_data[1][0], bg_black, board_data[1][1], bg_white, board_data[1][2], clear_to_eol,
             "3 ", bg_black, board_data[2][0], bg_white, board_data[2][1], bg_black, board_data[2][2], clear_to_eol,
             "   A   B   C\n"];

    sys.stdout.write("".join(board))

def get_movement_direction(colour):
    direction = -1
    if colour == black_pawn:
        direction = 1
    elif colour == white_pawn:
        direction = -1
    else:
        raise ValueError("Invalid piece colour")

    return direction

def get_other_colour(colour):
    if colour == black_pawn:
        return white_pawn
    elif colour == white_pawn:
        return black_pawn
    else:
        raise ValueError("Invalid piece colour")

def get_allowed_moves(board_data, row, col):
    if board_data[row][col] == empty_square:
        return set()

    colour = board_data[row][col]
    other_colour = get_other_colour(colour)
    direction = get_movement_direction(colour)

    if (row + direction < 0 or row + direction > 2):
        return set()

    allowed_moves = set()
    if board_data[row + direction][col] == empty_square:
        allowed_moves.add('f')
    if col > 0 and board_data[row + direction][col - 1] == other_colour:
        allowed_moves.add('dl')
    if col < 2 and board_data[row + direction][col + 1] == other_colour:
        allowed_moves.add('dr')

    return allowed_moves

def get_human_move(board_data, colour):
    # The direction the pawns may move depends on the colour; assuming that white starts at the bottom.
    direction = get_movement_direction(colour)

    while True:
        piece_posn = input(f'What {colour} do you want to move? ')
        valid_inputs = {'a1': (0,0), 'b1': (0,1), 'c1': (0,2),
                        'a2': (1,0), 'b2': (1,1), 'c2': (1,2),
                        'a3': (2,0), 'b3': (2,1), 'c3': (2,2)}
        if piece_posn not in valid_inputs:
            print("LOL that's not a valid position! Try again.")
            continue

        (row, col) = valid_inputs[piece_posn]
        piece = board_data[row][col]
        if piece == empty_square:
            print("What are you trying to pull, there's no piece in that space!")
            continue

        if piece != colour:
            print("LOL that's not your piece, try again!")
            continue

        allowed_moves = get_allowed_moves(board_data, row, col)

        if len(allowed_moves) == 0:
            print('LOL nice try. That piece has no valid moves.')
            continue

        move = list(allowed_moves)[0]
        if len(allowed_moves) > 1:
            move = input(f'What move do you want to make ({",".join(list(allowed_moves))})? ')
            if move not in allowed_moves:
                print('LOL that move is not allowed. Try again.')
                continue

        if move == 'f':
            board_data[row + direction][col] = board_data[row][col]
        elif move == 'dl':
            board_data[row + direction][col - 1] = board_data[row][col]
        elif move == 'dr':
            board_data[row + direction][col + 1] = board_data[row][col]

        board_data[row][col] = empty_square
        return board_data

def is_game_over(board_data, current_colour=None):
    if board_data[0][0] == white_pawn or board_data[0][1] == white_pawn or board_data[0][2] == white_pawn:
        return white_pawn

    if board_data[2][0] == black_pawn or board_data[2][1] == black_pawn or board_data[2][2] == black_pawn:
        return black_pawn

    white_count = 0
    black_count = 0
    black_allowed_moves = []
    white_allowed_moves = []
    for i in range(3):
        for j in range(3):
            moves = get_allowed_moves(board_data, i, j)

            if board_data[i][j] == white_pawn:
                white_count += 1
                if len(moves) > 0:
                    white_allowed_moves.append((i,j,moves))
            if board_data[i][j] == black_pawn:
                black_count += 1
                if len(moves) > 0:
                    black_allowed_moves.append((i,j,moves))
    # If current_colour is provided and has no moves, other player wins
    if current_colour is not None:
        if current_colour == white_pawn and len(white_allowed_moves) == 0:
            return black_pawn
        if current_colour == black_pawn and len(black_allowed_moves) == 0:
            return white_pawn

    if white_count == 0 or len(white_allowed_moves) == 0:
        return black_pawn
    if black_count == 0 or len(black_allowed_moves) == 0:
        return white_pawn

    return "LOL NOPE"

def play_game(black_move, white_move):

    board_data = [[black_pawn, black_pawn, black_pawn],
                  [empty_square, empty_square, empty_square],
                  [white_pawn, white_pawn, white_pawn]]

    last_player = black_pawn
    next_player = white_pawn
    while True:
        # Check if game is over before displaying the board
        if is_game_over(board_data, next_player) != "LOL NOPE":
           break
        draw_board(board_data)

        if (next_player == black_pawn):
            board_data = black_move(board_data, next_player)
        else:
            board_data = white_move(board_data, next_player)

        temp = last_player
        last_player = next_player
        next_player = temp

    # Display the final board state
    draw_board(board_data)
    winner = is_game_over(board_data, next_player)
    print(f'Congratulations {winner}!')

play_game(get_human_move, get_human_move)
