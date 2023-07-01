// the board is represented with a list of 16 integers
let empty = List.init 16 (fun _ -> 0)
let win = List.contains 2048

// a single movement (a hit) consists of stacking and then possible joining
let rec stack = function
    | 0 :: t -> stack t @ [0]
    | h :: t -> h :: stack t
    | [] -> []
let rec join = function
    | a :: b :: c when a = b -> (a + b :: join c) @ [0]
    | a :: b -> a :: join b
    | [] -> []
let hit = stack >> join
let hitBack = List.rev >> hit >> List.rev
let rows = List.chunkBySize 4
let left = rows >> List.map hit >> List.concat
let right = rows >> List.map hitBack >> List.concat
let up = rows >> List.transpose >> List.map hit >> List.transpose >> List.concat
let down = rows >> List.transpose >> List.map hitBack >> List.transpose >> List.concat

let lose g = left g = g && right g = g && up g = g && down g = g

// spawn a 2 or occasionally a 4 at a random unoccupied position
let random = System.Random()
let spawnOn g =
    let newTileValue = if random.Next 10 = 0 then 4 else 2
    let numZeroes = List.filter ((=) 0) >> List.length
    let newPosition = g |> numZeroes |> random.Next
    let rec insert what where = function
        | 0 :: tail when numZeroes tail = where -> what :: tail
        | h :: t -> h :: insert what where t
        | [] -> []
    insert newTileValue newPosition g

let show =
    let line = List.map (sprintf "%4i") >> String.concat " "
    rows >> List.map line >> String.concat "\n" >> printf "\n%s\n"

// use an empty list as a sign of user interrupt
let quit _ = []
let quitted = List.isEmpty

let dispatch = function | 'i' -> up | 'j' -> left | 'k' -> down | 'l' -> right | 'q' -> quit | _ -> id
let key() = System.Console.ReadKey().KeyChar |> char
let turn state =
    show state
    let nextState = (key() |> dispatch) state
    if nextState <> state && not (quitted nextState) then spawnOn nextState else nextState

let play() =
    let mutable state = spawnOn empty
    while not (win state || lose state || quitted state) do state <- turn state
    if quitted state then printfn "User interrupt" else
        show state
        if win state then printf "You win!"
        if lose state then printf "You lose!"

play()
