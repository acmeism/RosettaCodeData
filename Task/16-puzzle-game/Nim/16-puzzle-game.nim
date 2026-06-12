import std/[random, sequtils, strformat]
import gtk2, glib2

const
  BoardSize = 4
  GridSize = BoardSize + 2
  Right = "⇨"
  Left = "⇦"
  Up = "⇧"
  Down = "⇩"

type
  Value = 1..16
  Puzzle = array[BoardSize, array[BoardSize, Value]]
  PuzzleApp = object
    window: PWindow                                      # Main window.
    inOrder: Puzzle                                      # Target grid.
    puzzle: Puzzle                                       # Current grid.
    buttons: array[GridSize, array[GridSize, PButton]]   # Button grid.
    won: bool                                            # True if game won.
    moves: Natural                                       # Count of moves.


proc initPuzzle(puzzle: var Puzzle; data: openArray[Value]) =
  ## Initialize the puzzle with a list of values.
  var i = 0
  for row in puzzle.mitems:
    for cell in row.mitems:
      cell = data[i]
      inc i


proc showMessage(app: PuzzleApp) =
  ## Show winning message.
  let msg = &"You won in {app.moves} moves"
  let dialog = messageDialogNew(app.window, DIALOG_DESTROY_WITH_PARENT,
                                MESSAGE_INFO, BUTTONS_CLOSE, msg.cstring)
  discard dialog.run()
  dialog.destroy()


proc onQuit(button: PWidget) =
  ## Procedure called when clicking quit button.
  mainQuit()


proc rotateRow(puzzle: var Puzzle; row: Natural; left: bool) =
  ## Rotate a row left or right.
  if left:
    let first = puzzle[row][0]
    for i in 1..puzzle.high:
      puzzle[row][i-1] = puzzle[row][i]
    puzzle[row][^1] = first
  else:
    let last = puzzle[row][^1]
    for i in countdown(puzzle.high, 1):
      puzzle[row][i] = puzzle[row][i-1]
    puzzle[row][0] = last


proc rotateCol(puzzle: var Puzzle; col: Natural; up: bool) =
  ## Rotate a column up or down.
  if up:
    let first = puzzle[0][col]
    for i in 1..puzzle.high:
      puzzle[i-1][col] = puzzle[i][col]
    puzzle[^1][col] = first
  else:
    let last = puzzle[^1][col]
    for i in countdown(puzzle[0].high, 1):
      puzzle[i][col] = puzzle[i-1][col]
    puzzle[0][col] = last


proc findRowCol(app: PuzzleApp; button: PButton): (int, int) =
  ## Find the row and column of a button.
  for row in 0..BoardSize+1:
    for col in 0..Boardsize+1:
      if app.buttons[row][col] == button:
        return (row, col)


proc update(app: var PuzzleApp) =
  ## Update the grid.
  for row in 0..BoardSize+1:
    for col in 0..BoardSize+1:
      if col in 1..BoardSize:
        if row == 0:
          app.buttons[row][col].setLabel(Down)
        elif row == BoardSize + 1:
          app.buttons[row][col].setLabel(Up)
        else:
          app.buttons[row][col].setLabel(cstring($app.puzzle[row-1][col-1]))
      elif row in 1..BoardSize:
        if col == 0:
          app.buttons[row][col].setLabel(Right)
        elif col == BoardSize + 1:
          app.buttons[row][col].setLabel(Left)

  if app.puzzle == app.inOrder:
    app.won = true
    app.showMessage()


proc onClick(button: PButton; app: var PuzzleApp) =
  ## Procedure called when the user clicked a grid button.
  if not app.won:
    inc app.moves
    let (row, col) = app.findRowCol(button)
    if row == 0:
      app.puzzle.rotateCol(col - 1, false)
    elif row == BoardSize + 1:
      app.puzzle.rotateCol(col - 1, true)
    elif col == 0:
      app.puzzle.rotateRow(row - 1, false)
    elif col == BoardSize + 1:
      app.puzzle.rotateRow(row - 1, true)
    app.update()


proc newGame(button: PWidget; app: var PuzzleApp) =
  ## Prepare a new game.
  var values = toSeq(Value.low..Value.high)
  values.shuffle()
  app.puzzle.initPuzzle(values)
  app.won = false
  app.update()


proc onDestroyEvent(widget: PWidget; data: pointer): gboolean {.cdecl.} =
  ## Quit the application.
  mainQuit()


randomize()
nimInit()
var app: PuzzleApp
app.window = windowNew(WINDOW_TOPLEVEL)
app.window.setTitle("16 puzzle game")
app.window.setSizeRequest(328, 365)
discard app.window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

let vbox = vboxNew(false, 0)
app.window.add vbox

let toolbar = toolbarNew()
discard toolbar.insertItem("New game", nil, nil, nil, SIGNAL_FUNC(newGame), app.addr, 0)
discard toolbar.insertItem("Quit", nil, nil, nil, SIGNAL_FUNC(onQuit), nil, 1)
vbox.packStart(toolbar, false, false, 0)

let hbox = hboxNew(false, 5)
vbox.packEnd(hbox, true, true, 0)
let grid = tableNew(GridSize, GridSize, true)
grid.setRowSpacings(5)
grid.setColSpacings(5)
hbox.packStart(grid, true, true, 10)

for row in guint(0)..(BoardSize + 1):
  for col in guint(0)..(BoardSize + 1):
    if (row, col) in [(0.guint, 0.guint), (0, BoardSize + 1),
                      (BoardSize + 1, 0), (BoardSize + 1, BoardSize + 1)]:
      continue
    let button = buttonNew()
    button.setSizeRequest(45, 45)
    app.buttons[row][col] = button
    grid.attach(button, col, col + 1, row, row + 1, 0, 0, 1, 1)

var values = toSeq(Value.low..Value.high)
app.inOrder.initPuzzle(values)
values.shuffle()
app.puzzle.initPuzzle(values)

for row in [0, BoardSize + 1]:
  for col in 1..BoardSize:
    discard app.buttons[row][col].signalConnect("clicked", SIGNAL_FUNC(onClick), app.addr)
for col in [0, BoardSize + 1]:
  for row in 1..BoardSize:
    discard app.buttons[row][col].signalConnect("clicked", SIGNAL_FUNC(onClick), app.addr)

app.won = false
app.update()
app.window.showAll()
main()
