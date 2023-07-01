import options, random, sequtils, strutils

type
  Board = array[1..9, char]
  Score = (char, array[3, int])

const NoChoice = 0

var board: Board = ['1', '2', '3', '4', '5', '6', '7', '8', '9']

const Wins = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
              [1, 4, 7], [2, 5, 8], [3, 6, 9],
              [1, 5, 9], [3, 5, 7]]

template toIndex(ch: char): int =
  ## Convert a character to an index in board.
  ord(ch) - ord('0')

proc print(board: Board) =
  for i in [1, 4, 7]:
    echo board[i..(i + 2)].join(" ")

proc score(board: Board): Option[Score] =
  for w in Wins:
    let b = board[w[0]]
    if b in "XO" and w.allIt(board[it] == b):
      return some (b, w)
  result = none(Score)

proc finished(board: Board): bool =
  board.allIt(it in "XO")

proc space(board: Board): seq[char] =
  for b in board:
    if b notin "XO":
      result.add b

proc myTurn(board: var Board; xo: char): char =
  let options = board.space()
  result = options.sample()
  board[result.toIndex] = xo

proc myBetterTurn(board: var Board; xo: char): int =
  let ox = if xo == 'X': 'O' else: 'X'
  var oneBlock = NoChoice
  let options = board.space.mapIt(it.toIndex)
  block search:
    for choice in options:
      var brd = board
      brd[choice] = xo
      if brd.score.isSome:
        result = choice
        break search
      if oneBlock == NoChoice:
        brd[choice] = ox
        if brd.score.isSome:
          oneBlock = choice
    result = if oneBlock != NoChoice: oneBlock else: options.sample()
  board[result] = xo

proc yourTurn(board: var Board; xo: char): int =
  let options = board.space()
  var choice: char
  while true:
    stdout.write "\nPut your $# in any of these positions: $# ".format(xo, options.join())
    let input = stdin.readLine().strip()
    if input.len == 1 and input[0] in options:
      choice = input[0]
      break
    echo "Whoops I don't understand the input"
  result = choice.toIndex
  board[result] = xo

proc me(board: var Board; xo: char): Option[Score] =
  board.print()
  echo "\nI go at ", board.myBetterTurn(xo)
  result = board.score()

proc you(board: var Board; xo: char): Option[Score] =
  board.print()
  echo "\nYou went at ", board.yourTurn(xo)
  result = board.score()

proc play() =
  while not board.finished():
    let score = board.me('X')
    if score.isSome:
      board.print()
      let (winner, line) = score.get()
      echo "\n$# wins along ($#).".format(winner, line.join(", "))
      return
    if not board.finished():
      let score = board.you('O')
      if score.isSome:
        board.print()
        let (winner, line) = score.get()
        echo "\n$# wins along ($#).".format(winner, line.join(", "))
        return
  echo "\nA draw."

echo "Tic-tac-toe game player."
echo "Input the index of where you wish to place your mark at your turn."
randomize()
play()
