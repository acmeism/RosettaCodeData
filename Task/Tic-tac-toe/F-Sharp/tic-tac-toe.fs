type Brick =
 | Empty
 | Computer
 | User

let brickToString = function
 | Empty -> ' '
 | Computer -> 'X'
 | User -> 'O'

// y -> x -> Brick
type Board = Map<int, Map<int, Brick> >

let emptyBoard =
  let emptyRow = Map.ofList [0,Empty; 1,Empty; 2,Empty]
  Map.ofList [0,emptyRow; 1,emptyRow; 2,emptyRow]

let get (b:Board) (x,y) = b.[y].[x]

let set player (b:Board) (x,y) : Board =
  let row = b.[y].Add(x, player)
  b.Add(y, row)

let winningPositions =
  [for x in [0..2] -> x,x] // first diagonal
  ::[for x in [0..2] -> 2-x,x] // second diagonal
  ::[for y in [0..2] do
     yield! [[for x in [0..2]->(y,x)]; // columns
             [for x in [0..2] -> (x,y)]]] // rows

let hasWon player board =
  List.exists
    (fun ps -> List.forall (fun pos -> get board pos = player) ps)
    winningPositions

let freeSpace board =
  [for x in 0..2 do
     for y in 0..2 do
       if get board (x,y) = Empty then yield x,y]

type Evaluation =
 | Win
 | Draw
 | Lose

let rec evaluate board move =
  let b2 = set Computer board move
  if hasWon Computer b2 then Win
  else
    match freeSpace b2 with
    | [] -> Draw
    | userChoices ->
       let b3s = List.map (set User b2) userChoices
       if List.exists (hasWon User) b3s then Lose
       elif List.exists (fun b3 -> bestOutcome b3 = Lose) b3s
       then Lose
       elif List.exists (fun b3 -> bestOutcome b3 = Draw) b3s
       then Draw
       else Win

and findBestChoice b =
  match freeSpace b with
  | [] -> ((-1,-1), Draw)
  | choices ->
    match List.tryFind (fun c -> evaluate b c = Win) choices with
    | Some c -> (c, Win)
    | None -> match List.tryFind (fun c -> evaluate b c = Draw) choices with
              | Some c -> (c, Draw)
              | None -> (List.head choices, Lose)

and bestOutcome b = snd (findBestChoice b)

let bestChoice b = fst (findBestChoice b)

let computerPlay b = set Computer b (bestChoice b)

let printBoard b =
  printfn "   | A | B | C |"
  printfn "---+---+---+---+"
  for y in 0..2 do
   printfn " %d | %c | %c | %c |"
    (3-y)
    (get b (0,y) |> brickToString)
    (get b (1,y) |> brickToString)
    (get b (2,y) |> brickToString)
   printfn "---+---+---+---+"

let rec userPlay b =
  printfn "Which field do you play? (format: a1)"
  let input = System.Console.ReadLine()
  if input.Length <> 2
     || input.[0] < 'a' || input.[0] > 'c'
     || input.[1] < '1' || input.[1] > '3' then
     printfn "illegal input"
     userPlay b
  else
     let x = int(input.[0]) - int('a')
     let y = 2 - int(input.[1]) + int('1')
     if get b (x,y) <> Empty then
       printfn "Field is not free."
       userPlay b
     else
       set User b (x,y)

let rec gameLoop b player =
  if freeSpace b = [] then
    printfn "Game over. Draw."
  elif player = Computer then
    printfn "Computer plays..."
    let b2 = computerPlay b
    printBoard b2
    if hasWon Computer b2 then
      printfn "Game over. I have won."
    else
      gameLoop b2 User
  elif player = User then
    let b2 = userPlay b
    printBoard b2
    if hasWon User b2 then
      printfn "Game over. You have won."
    else
      gameLoop b2 Computer

// randomly choose an element of a list
let choose =
  let rnd = new System.Random()
  fun (xs:_ list) -> xs.[rnd.Next(xs.Length)]

// play first brick randomly
printfn "Computer starts."
let b = set Computer emptyBoard (choose (freeSpace emptyBoard))
printBoard b
gameLoop b User
