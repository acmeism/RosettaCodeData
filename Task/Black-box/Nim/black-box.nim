import random, sequtils, strutils

const WikiGame = true

type

  Game = object
    b: array[100, char]   # displayed board.
    h: array[100, char]   # hidden atoms.


proc hideAtoms(game: var Game) =
  var placed = 0
  while placed < 4:
    let a = rand(11..88)
    let m = a mod 10
    if m == 0 or m == 9 or game.h[a] == 'T':
      continue
    game.h[a] = 'T'
    inc placed


proc initGame(): Game =
  for i in 0..99:
    result.b[i] = ' '
    result.h[i] = 'F'
  if not WikiGame:
    result.hideAtoms()
  else:
    result.h[32] = 'T'
    result.h[37] = 'T'
    result.h[64] = 'T'
    result.h[87] = 'T'


proc drawGrid(game: Game; score, guesses: Natural) =
  echo "      0   1   2   3   4   5   6   7   8   9\n"
  echo "        ╔═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╗"
  echo "a     $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $#".format(game.b[0..9].mapIt($it))
  echo "    ╔═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╗"
  echo "b   ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║".format(game.b[10..19].mapIt($it))
  echo "    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣"
  echo "c   ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║".format(game.b[20..29].mapIt($it))
  echo "    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣"
  echo "d   ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║".format(game.b[30..39].mapIt($it))
  echo "    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣"
  echo "e   ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║".format(game.b[40..49].mapIt($it))
  echo "    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣"
  echo "f   ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║".format(game.b[50..59].mapIt($it))
  echo "    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣"
  echo "g   ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║".format(game.b[60..69].mapIt($it))
  echo "    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣"
  echo "h   ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║".format(game.b[70..79].mapIt($it))
  echo "    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣"
  echo "i   ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║".format(game.b[80..89].mapIt($it))
  echo "    ╚═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╝"
  echo "j     $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $# ║ $#".format(game.b[90..99].mapIt($it))
  echo "        ╚═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╝"

  let status = if guesses == 4: "Game over!" else: "In play"
  echo "\n        Score = ", score, "\tGuesses = ", guesses, "\t Status = ", status, '\n'


proc finalScore(game: var Game; score, guesses: Natural) =
  var score = score
  for i in 11..88:
    let m = i mod 10
    if m in [0, 9]: continue
    if game.b[i] == 'G':
      if game.h[i] == 'T':
        game.b[i] = 'Y'
      else:
        game.b[i] = 'N'
        inc score, 5
    elif game.b[i] == ' ' and game.h[i] == 'T':
      game.b[i] = 'A'
  game.drawGrid(score, guesses)


func atCorner(ix: int): bool = ix in [0, 9, 90, 99]

func inRange(ix: int): bool = ix in 1..98 and ix notin [9, 90]

func atTop(ix: int): bool = ix in 1..8

func atBottom(ix: int): bool = ix in 91..98

func atLeft(ix: int): bool = ix.inRange and ix mod 10 == 0

func atRight(ix: int): bool = ix.inRange and ix mod 10 == 9

func inMiddle(ix: int): bool =
  ix.inRange and not (ix.atTop or ix.atBottom or ix.atLeft or ix.atRight)


proc nextCell(game: Game): int =
  while true:
    stdout.write "    Choose cell: "
    stdout.flushFile()
    try:
      let sq = stdin.readLine().toLowerAscii
      if sq == "q":
        quit "Quitting.", QuitSuccess
      if sq.len != 2 or sq[0] notin 'a'..'j' or sq[1] notin '0'..'9':
        continue
      result = int((ord(sq[0]) - ord('a')) * 10 + ord(sq[1]) - ord('0'))
      if not result.atCorner: break
    except EOFError:
      echo()
      quit "Encountered end of file. Quitting.", QuitFailure
  echo()


proc play(game: var Game) =
  var score, guesses = 0
  var num = '0'

  block outer:
    while true:
      block inner:
        game.drawGrid(score, guesses)
        let ix = game.nextCell()
        if not ix.inMiddle and game.b[ix] != ' ':     # already processed.
          continue
        var incr, def: int
        if ix.atTop:
          (incr, def) = (10, 1)
        elif ix.atBottom:
          (incr, def) = (-10, 1)
        elif ix.atLeft:
          (incr, def) = (1, 10)
        elif ix.atRight:
          (incr, def) = (-1, 10)
        else:
          if game.b[ix] != 'G':
            game.b[ix] = 'G'
            inc guesses
            if guesses == 4: break outer
          else:
            game.b[ix] = ' '
            dec guesses
          continue

        var first = true
        var x = ix + incr
        while x.inMiddle:

          if game.h[x] == 'T':
            # Hit.
            game.b[ix] = 'H'
            inc score
            first = false
            break inner

          if first and (x + def).inMiddle and game.h[x + def] == 'T' or
                       (x - def).inMiddle and game.h[x - def] == 'T':
            # Reflection.
            game.b[ix] = 'R'
            inc score
            first = false
            break inner

          first = false
          var y = x + incr - def
          if y.inMiddle and game.h[y] == 'T':
            # Deflection.
            (incr, def) = if incr in [-1, 1]: (10, 1) else: (1, 10)

          y = x + incr + def
          if y.inMiddle and game.h[y] == 'T':
            # Deflection or double deflection.
            (incr, def) = if incr in [-1, 1]: (-10, 1) else: (-1, 10)

          inc x, incr

        num = if num != '9': succ(num) else: 'a'
        if game.b[ix] == ' ': inc score
        game.b[ix] = num
        if x.inRange:
          if ix == x:
            game.b[ix] = 'R'
          else:
            if game.b[x] == ' ': inc score
            game.b[x] = num

  game.drawGrid(score, guesses)
  game.finalScore(score, guesses)


proc main() =

  randomize()
  while true:
    var game = initGame()
    echo """
    === BLACK BOX ===

      H    Hit (scores 1)
      R    Reflection (scores 1)
      1-9, Detour (scores 2)
      a-c  Detour for 10-12 (scores 2)
      G    Guess (maximum 4)
      Y    Correct guess
      N    Incorrect guess (scores 5)
      A    Unguessed atom

      Cells are numbered a0 to j9.
      Corner cells do nothing.
      Use edge cells to fire beam.
      Use middle cells to add/delete a guess.
      Game ends automatically after 4 guesses.
      Enter q to abort game at any time.
    """

    game.play()

    while true:
      stdout.write "    Play again (y/n): "
      stdout.flushFile()
      case stdin.readLine().toLowerAscii()
      of "n": return
      of "y": break

main()
