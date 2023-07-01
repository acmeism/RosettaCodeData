import macros, os, random
import ncurses

when defined(Linux):
  proc positional_putch(x, y: int; ch: char) = mvaddch(x.cint, y.cint, ch.chtype)
  proc updateScreen = refresh()
  proc nonBlockingGetch(): char =
    let c = getch()
    result = if c in 0..255: char(c) else: '\0'
  proc closeScreen = endwin()

else:
  error "Not implemented"

const

  W = 80
  H = 40
  Space = 0
  Food = 1
  Border = 2
  Symbol = [' ', '@', '.']

type

  Dir {.pure.} = enum North, East, South, West
  Game = object
    board: array[W * H, int]
    head: int
    dir: Dir
    quit: bool


proc age(game: var Game) =
  ## Reduce a time-to-live, effectively erasing the tail.
  for i in 0..<W*H:
    if game.board[i] < 0: inc game.board[i]


proc plant(game: var Game) =
  ## Put a piece of food at random empty position.
  var r: int
  while true:
    r = rand(W * H - 1)
    if game.board[r] == Space: break
  game.board[r] = Food


proc start(game: var Game) =
  ## Initialize the board, plant a very first food item.
  for i in 0..<W:
    game.board[i] = Border
    game.board[i + (H - 1) * W] = Border
  for i in 0..<H:
    game.board[i * W] = Border
    game.board[i * W + W - 1] = Border
  game.head = W * (H - 1 - (H and 1)) shr 1   # Screen center for any H.
  game.board[game.head] = -5
  game.dir = North
  game.quit = false
  game.plant()


proc step(game: var Game) =
  let len = game.board[game.head]
  case game.dir
  of North: dec game.head, W
  of South: inc game.head, W
  of West: dec game.head
  of East: inc game.head

  case game.board[game.head]
  of Space:
    game.board[game.head] = len - 1  # Keep in mind "len" is negative.
    game.age()
  of Food:
    game.board[game.head] = len - 1
    game.plant()
  else:
    game.quit = true


proc show(game: Game) =
  for i in 0..<W*H:
    positionalPutch(i div W, i mod W, if game.board[i] < 0: '#' else: Symbol[game.board[i]])
  updateScreen()


var game: Game
randomize()
let win = initscr()
cbreak()              # Make sure thre is no buffering.
noecho()              # Suppress echoing of characters.
nodelay(win, true)    # Non-blocking mode.
game.start()

while not game.quit:
  game.show()
  case nonBlockingGetch()
  of 'i': game.dir = North
  of 'j': game.dir = West
  of 'k': game.dir = South
  of 'l': game.dir = East
  of 'q': game.quit = true
  else: discard
  game.step()
  os.sleep(300)       # Adjust here: 100 is very fast.

sleep(1000)
closeScreen()
