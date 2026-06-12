from numpy import array, arange, any
from functools import reduce
from random import choices

def rotate_rowcol(arr, n, direction):
    row = array(arr[n, ...])
    col = array(arr[..., n])
    match direction:
        case "left":
            arr[n, :-1] = row[1:]
            arr[n, -1] = row[0]
        case "right":
            arr[n, 1:] = row[:-1]
            arr[n, 0] = row[-1]
        case "up":
            arr[:-1, n] = col[1:]
            arr[-1, n] = col[0]
        case "down":
            arr[1:, n] = col[:-1]
            arr[0, n] = col[-1]
    return arr

def sixteen_game():
    while True:
        difficulty = input("Choose difficulty level (easy or hard): ").lower()
        if difficulty in ["easy", "hard"]:
            break
        else:
            print("\nThat's not a valid difficulty. Try again!")

    if difficulty == "easy":
        maxmoves=3
    elif difficulty == "hard":
        maxmoves=12

    dirs = choices(["left", "right", "up", "down"], k=maxmoves)
    nums = choices(range(4), k=maxmoves)
    funs = map(lambda x: lambda arr: rotate_rowcol(arr, nums[x], dirs[x]), range(maxmoves))
    initial_board = reduce(lambda x,f: f(x), funs, arange(1, 17).reshape(4, 4))
    print(initial_board)

    turns = 1
    while any(initial_board!=arange(1, 17).reshape(4, 4)):
        print("\nTurn %d:"%turns)
        d = input("Choose a direction to rotate (up, down, left, or right): ").lower()
        if d in ["left", "right"]:
            row = int(input("Enter a row number: "))
            initial_board = rotate_rowcol(initial_board, row, d)
            print(initial_board)
            turns += 1
        elif d in ["up", "down"]:
            col = int(input("Enter a column number: "))
            initial_board = rotate_rowcol(initial_board, col, d)
            print(initial_board)
            turns += 1
        else:
            print("\nThat's not a valid direction. Try again!")

    print("\nWell done! You finished in", turns-1, "move(s).")

sixteen_game()
