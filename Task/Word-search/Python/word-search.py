import re
from random import shuffle, randint

dirs = [[1, 0], [0, 1], [1, 1], [1, -1], [-1, 0], [0, -1], [-1, -1], [-1, 1]]
n_rows = 10
n_cols = 10
grid_size = n_rows * n_cols
min_words = 25


class Grid:
    def __init__(self):
        self.num_attempts = 0
        self.cells = [['' for _ in range(n_cols)] for _ in range(n_rows)]
        self.solutions = []


def read_words(filename):
    max_len = max(n_rows, n_cols)

    words = []
    with open(filename, "r") as file:
        for line in file:
            s = line.strip().lower()
            if re.match(r'^[a-z]{3,' + re.escape(str(max_len)) + r'}$', s) is not None:
                words.append(s)

    return words


def place_message(grid, msg):
    msg = re.sub(r'[^A-Z]', "", msg.upper())

    message_len = len(msg)
    if 0 < message_len < grid_size:
        gap_size = grid_size // message_len

        for i in range(0, message_len):
            pos = i * gap_size + randint(0, gap_size)
            grid.cells[pos // n_cols][pos % n_cols] = msg[i]

        return message_len

    return 0


def try_location(grid, word, direction, pos):
    r = pos // n_cols
    c = pos % n_cols
    length = len(word)

    # check bounds
    if (dirs[direction][0] == 1 and (length + c) > n_cols) or \
       (dirs[direction][0] == -1 and (length - 1) > c) or \
       (dirs[direction][1] == 1 and (length + r) > n_rows) or \
       (dirs[direction][1] == -1 and (length - 1) > r):
        return 0

    rr = r
    cc = c
    i = 0
    overlaps = 0

    # check cells
    while i < length:
        if grid.cells[rr][cc] != '' and grid.cells[rr][cc] != word[i]:
            return 0
        cc += dirs[direction][0]
        rr += dirs[direction][1]
        i += 1

    rr = r
    cc = c
    i = 0
    # place
    while i < length:
        if grid.cells[rr][cc] == word[i]:
            overlaps += 1
        else:
            grid.cells[rr][cc] = word[i]

        if i < length - 1:
            cc += dirs[direction][0]
            rr += dirs[direction][1]

        i += 1

    letters_placed = length - overlaps
    if letters_placed > 0:
        grid.solutions.append("{0:<10} ({1},{2})({3},{4})".format(word, c, r, cc, rr))

    return letters_placed


def try_place_word(grid, word):
    rand_dir = randint(0, len(dirs))
    rand_pos = randint(0, grid_size)

    for direction in range(0, len(dirs)):
        direction = (direction + rand_dir) % len(dirs)

        for pos in range(0, grid_size):
            pos = (pos + rand_pos) % grid_size

            letters_placed = try_location(grid, word, direction, pos)
            if letters_placed > 0:
                return letters_placed

    return 0


def create_word_search(words):
    grid = None
    num_attempts = 0

    while num_attempts < 100:
        num_attempts += 1
        shuffle(words)

        grid = Grid()
        message_len = place_message(grid, "Rosetta Code")
        target = grid_size - message_len

        cells_filled = 0
        for word in words:
            cells_filled += try_place_word(grid, word)
            if cells_filled == target:
                if len(grid.solutions) >= min_words:
                    grid.num_attempts = num_attempts
                    return grid
                else:
                    break # grid is full but we didn't pack enough words, start over

    return grid


def print_result(grid):
    if grid is None or grid.num_attempts == 0:
        print("No grid to display")
        return

    size = len(grid.solutions)

    print("Attempts: {0}".format(grid.num_attempts))
    print("Number of words: {0}".format(size))

    print("\n     0  1  2  3  4  5  6  7  8  9\n")
    for r in range(0, n_rows):
        print("{0}   ".format(r), end='')
        for c in range(0, n_cols):
            print(" %c " % grid.cells[r][c], end='')
        print()
    print()

    for i in range(0, size - 1, 2):
        print("{0}   {1}".format(grid.solutions[i], grid.solutions[i+1]))

    if size % 2 == 1:
        print(grid.solutions[size - 1])


if __name__ == "__main__":
    print_result(create_word_search(read_words("unixdict.txt")))
