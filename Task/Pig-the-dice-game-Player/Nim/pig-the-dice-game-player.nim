import random, strformat

const MaxPoints = 100

type

  Move {.pure.} = enum Roll, Hold
  Strategy {.pure.} = enum Rand, Q2Win, AL20, AL20T

  # Player description.
  Player = ref object
    num: Natural
    currentScore: Natural
    roundScore: Natural
    strategy: Strategy
    next: Player

  # Player list managed as a singly linked ring.
  PlayerList = object
    count: Natural
    head, tail: Player


proc addPlayer(playerList: var PlayerList; strategy: Strategy) =
  ## Add a player with given strategy.
  inc playerList.count
  let newPlayer = Player(num: playerList.count, strategy: strategy)
  if playerList.head.isNil:
    playerList.head = newPlayer
  else:
    playerList.tail.next = newPlayer
  playerList.tail = newPlayer
  newPlayer.next = playerList.head


iterator items(playerList: PlayerList): Player =
  ## Yield the successive players of a player list.
  var player = playerList.head
  yield player
  while player != playerList.tail:
    player = player.next
    yield player


proc getMove(player: Player): Move =
  ## Get the move for the given player.

  if player.roundScore + player.currentScore >= MaxPoints: return Hold

  case player.strategy

  of Strategy.Rand:
    result = if rand(1) == 0: Roll
             elif player.roundScore > 0: Hold
             else: Roll

  of Strategy.Q2Win:
    let q = MaxPoints - player.currentScore
    result = if q < 6 or player.roundScore < q div 4: Roll
             else: Hold

  of Strategy.AL20:
    result = if player.roundScore < 20: Roll
             else: Hold

  of Strategy.AL20T:
    let d = 5 * player.roundScore
    result = if player.roundScore < 20 and d < rand(99): Roll
             else: Hold


randomize()

# Create player list.
var playerList = PlayerList()
for strategy in Strategy.low..Strategy.high:
  playerList.addPlayer(strategy)

var endGame = false
var player = playerList.head

while not endGame:
  case player.getMove()

  of Roll:
    let die = rand(1..6)
    if die == 1:
      echo &"Player {player.num} rolled {die}  Current score: {player.currentScore:3}\n"
      player.roundScore = 0
      player = player.next
      continue
    inc player.roundScore, die
    echo &"Player {player.num} rolled {die}    Round score: {player.roundScore:3}"

  of Hold:
    inc player.currentScore, player.roundScore
    echo &"Player {player.num} holds     Current score: {player.currentScore:3}\n"
    if player.currentScore >= MaxPoints:
      endGame = true
    else:
      player.roundScore = 0
      player = player.next

for player in playerList:
  let stratStr = &"({player.strategy}):"
  echo &"Player {player.num} {stratStr:8} {player.currentScore:3}"
