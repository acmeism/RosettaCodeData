import curses
import random
import time

"""

Based on C ncurses version

http://rosettacode.org/wiki/Matrix_Digital_Rain#NCURSES_version

"""

"""
Time between row updates in seconds
Controls the speed of the digital rain effect.
"""

ROW_DELAY=.0001

def get_rand_in_range(min, max):
    return random.randrange(min,max+1)

try:
    # Characters to randomly appear in the rain sequence.
    chars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

    total_chars = len(chars)

    stdscr = curses.initscr()
    curses.noecho()
    curses.curs_set(False)

    curses.start_color()
    curses.init_pair(1, curses.COLOR_GREEN, curses.COLOR_BLACK)
    stdscr.attron(curses.color_pair(1))

    max_x = curses.COLS - 1
    max_y = curses.LINES - 1


    # Create arrays of columns based on screen width.

    # Array containing the current row of each column.

    columns_row = []

    # Array containing the active status of each column.
    # A column draws characters on a row when active.

    columns_active = []

    for i in range(max_x+1):
        columns_row.append(-1)
        columns_active.append(0)

    while(True):
        for i in range(max_x):
            if columns_row[i] == -1:
                # If a column is at the top row, pick a
                # random starting row and active status.
                columns_row[i] = get_rand_in_range(0, max_y)
                columns_active[i] = get_rand_in_range(0, 1)

        # Loop through columns and draw characters on rows

        for i in range(max_x):
            if columns_active[i] == 1:
                # Draw a random character at this column's current row.
                char_index = get_rand_in_range(0, total_chars-1)
                #mvprintw(columns_row[i], i, "%c", chars[char_index])
                stdscr.addstr(columns_row[i], i, chars[char_index])
            else:
                # Draw an empty character if the column is inactive.
                #mvprintw(columns_row[i], i, " ");
                stdscr.addstr(columns_row[i], i, " ");


            columns_row[i]+=1

            # When a column reaches the bottom row, reset to top.
            if columns_row[i] >= max_y:
                columns_row[i] = -1

            # Randomly alternate the column's active status.
            if get_rand_in_range(0, 1000) == 0:
                if columns_active[i] == 0:
                    columns_active[i] = 1
                else:
                    columns_active[i] = 0

            time.sleep(ROW_DELAY)
            stdscr.refresh()

except KeyboardInterrupt as err:
    curses.endwin()
