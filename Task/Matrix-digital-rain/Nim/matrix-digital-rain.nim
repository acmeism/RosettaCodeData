import os, random, sequtils
import ncurses

const RowDelay = 40   # In milliseconds.

proc exit() {.noconv.} =
  endwin()
  quit QuitSuccess

proc run() =

  const
    Chars = "0123456789"    # Characters to randomly appear in the rain sequence.

  let stdscr = initscr()
  noEcho()
  cursSet(0)
  startColor()
  initPair(1, COLOR_GREEN, COLOR_BLACK)
  attron(COLOR_PAIR(1).cint)

  var width, height: cint
  stdscr.getmaxyx(height, width)
  let maxX = width - 1
  let maxY = height - 1

  # Create arrays of columns based on screen width.

  # Array containing the current row of each column.
  # Set top row as current row for all columns.
  var columnsRow = repeat(cint -1, width)

  # Array containing the active status of each column.
  # A column draws characters on a row when active.
  var columnsActive = newSeq[bool](width)


  setControlCHook(exit)
  while true:

    for i in 0..maxX:
      if columnsRow[i] == -1:
        # If a column is at the top row, pick a random starting row and active status.
        columnsRow[i] = cint(rand(maxY))
        columnsActive[i] = bool(rand(1))

    # Loop through columns and draw characters on rows.
    for i in 0..maxX:
      if columnsActive[i]:
        # Draw a random character at this column's current row.
        let charIndex = rand(Chars.high)
        mvprintw(columnsRow[i], i, "%c", Chars[charIndex])
      else:
        # Draw an empty character if the column is inactive.
        mvprintw(columnsRow[i], i, " ")

      inc columnsRow[i]
      # When a column reaches the bottom row, reset to top.
      if columnsRow[i] > maxY: columnsRow[i] = -1

      # Randomly alternate the column's active status.
      if rand(999) == 0: columnsActive[i] = not columnsActive[i]

    sleep(RowDelay)
    refresh()

run()
