import random, strformat, strutils

type Adjacent = array[3, int]

const Cave: array[1..20, Adjacent] =
    [ 1: [2, 3, 4],     2: [1, 5, 6],     3: [1, 7, 8],     4: [1, 9, 10],
      5: [2, 9, 11],    6: [2, 7, 12],    7: [3, 6, 13],    8: [3, 10, 14],
      9: [4, 5, 15],   10: [4, 8, 16],   11: [5, 12, 17],  12: [6, 11, 18],
     13: [7, 14, 18],  14: [8, 13, 19],  15: [9, 16, 17],  16: [10, 15, 19],
     17: [11, 20, 15], 18: [12, 13, 20], 19: [14, 16, 20], 20: [17, 18, 19]]

type Game = object
  player: int
  wumpus: int
  bat1: int
  bat2: int
  pit1: int
  pit2: int
  arrows: int


proc initGame(): Game =
  result.player = 1
  result.wumpus = rand(2..20)
  result.bat1 = rand(2..20)
  while true:
    result.bat2 = rand(2..20)
    if result.bat2 != result.bat1: break
  while true:
    result.pit1 = rand(2..20)
    if result.pit1 notin [result.bat1, result.bat2]: break
  while true:
    result.pit2 = rand(2..20)
    if result.pit2 notin [result.bat1, result.bat2, result.pit1]: break
  result.arrows = 5


func isEmpty(game: Game; room: int): bool =
  room notin [game.player, game.wumpus, game.bat1, game.bat2, game.pit1, game.pit2]



proc sense(game: Game; adj: Adjacent) =
  var bat, pit = false
  for ar in adj:
    if ar == game.wumpus:
      echo "You smell something terrible nearby."
    if ar in [game.bat1, game.bat2]:
      if not bat:
        echo "You hear a rustling."
        bat = true
    elif ar in [game.pit1, game.pit2]:
      if not pit:
        echo "You feel a cold wind blowing from a nearby cavern."
        pit = true
  echo()


func plural(n: int): string =
  if n > 1: "s" else: ""


proc play(game: var Game) =

  while true:

    echo &"\nYou are in room {game.player} with {game.arrows} arrow{plural(game.arrows)} left"
    let adj = Cave[game.player]
    echo "The adjacent rooms are ", adj.join(", ")
    game.sense(adj)

    var room: int
    while true:
      stdout.write "Choose an adjacent room: "
      stdout.flushFile()
      try:
        room = stdin.readLine().parseInt()
        if room notin adj:
          raise newException(ValueError, "")
        break
      except ValueError:
        echo "Invalid response, try again"
      except EOFError:
        quit "\nEnd of file encountered; quitting.", QuitFailure

    var action: char
    while true:
      stdout.write "Walk or shoot (w/s): "
      stdout.flushFile()
      try:
        let reply = stdin.readLine()
        if reply.len != 1 or reply[0] notin ['w', 's']:
          echo "Invalid response, try again"
        action = reply[0]
        break
      except EOFError:
        quit "\nEnd of file encountered; quitting.", QuitFailure

    if action == 'w':
      game.player = room
      if game.player == game.wumpus:
        echo "You have been eaten by the Wumpus and lost the game!"
        return
      if game.player in [game.pit1, game.pit2]:
        echo "You have fallen down a bottomless pit and lost the game!"
        return
      if game.player in [game.bat1, game.bat2]:
        while true:
          room = rand(2..20)
          if game.isEmpty(room):
            echo "A bat has transported you to a random empty room"
            game.player = room
            break

    else:
      if room == game.wumpus:
        echo "You have killed the Wumpus and won the game!!"
        return
      let chance = rand(3)
      if chance > 0:
        game.wumpus = Cave[game.wumpus].sample()
        if game.player == game.wumpus:
          echo "You have been eaten by the Wumpus and lost the game!"
          return
      dec game.arrows
      if game.arrows == 0:
        echo "You have run out of arrows and lost the game!"
        return


randomize()
var game = initGame()
game.play()
