open System
open System.Threading.Tasks
open System.Threading

module SnakeGame =

    /// 🚏 Directions on our grid:
    type Movement =
        | Left of Position
        | Right of Position
        | Down of Position
        | Up of Position
        | InvalidMove

    /// 🐍 Sort of like a list, but not:
    and Snake<'Position> =
        | Head of Position * Snake<'Position>
        | Belly of Position * Snake<'Position>
        | Tail

    /// 🕹️ Our basic runtime information:
    and Game =
        | GameRunning of Movement * Snake<Position> * Grid * Eaten:int * Food
        | GameOver of Grid * Eaten:int

    /// 🧭 x & y in our plane:
    and Position = int * int

    /// 🍎 The food our snake will eat:
    and Food = Position * string

    /// 🌐 A simple two dimensional plane:
    and Grid = string[][]

    /// Making a list of positions from a Snake 🐍
    let snakeUnzip (snake:Snake<Position>) =
        let rec unzip snake carry =
            match snake with
            | Head (p, rest) -> unzip rest <| carry @ [p]
            | Belly (p, rest) -> unzip rest <| carry @ [p]
            | Tail -> carry
        unzip snake []

    /// Making a Snake from a list of positions 🐍
    let snakeZip (positions:list<Position>) (upto:int) =
        let correctLength = (List.take upto positions)
        let rec zip (carry:Snake<Position>) (rest:list<Position>) =
            match rest with
            | head::[] -> zip (Head(head, carry)) []
            | back::front -> zip (Belly (back, carry)) front
            | [] -> carry
        zip Tail (List.rev correctLength)

    module Graphics =
        let private random = new Random()
        let private head = "🤢"
        let private belly = "🟢"
        let private display = "⬜"
        let private errorDisplay = "🟥"

        let private food = [|"🐁";"🐀";"🐥";"🪺";"🐸";"🐛";"🪰";"🐞";"🦗"|]
        let private randomFood () = food.[random.Next(food.Length - 1)]

        let isFood square = Array.contains square food
        let isFreeSpace square = square = display || square = errorDisplay
        let isOccupied square =
            match square with
            | square when isFreeSpace square -> false
            | square when isFood square -> false
            | _ -> true

        let makeGrid (dimensionsSquared) : Grid =
            let row _ = Array.init dimensionsSquared (fun _ -> display)
            Array.init dimensionsSquared row

        let clearGrid (grid:Grid) : unit =
            Array.iteri (fun i row ->
                Array.iteri (fun j _ ->
                    grid.[i].[j] <- display
                ) row
            ) grid

        let render (grid:Grid) : unit =
            Console.Clear()
            Array.iter (fun (row:string array) ->
                let prettyprint = String.concat "" row
                printfn $"{prettyprint}") grid
            printfn "Snake Game in FSharp by @wiredsister"
            printfn "Controls: ⬅️ ↕️ ➡️"
            printfn "Press Ctrl+C to Quit Game"
            Console.Title <- "FSharp Snake 🐍"

        let getFreeSpaces (grid:Grid) : list<Position> =
            let results : Position list ref = ref []
            for i in 0..(grid.Length-1) do
                for j in 0..(grid.Length-1) do
                    if isFreeSpace grid.[i].[j]
                    then results.Value <- results.Value @ [i,j]
                    else ()
                ()
            results.Value

        let getFood (grid:Grid) : Food =
            Console.Beep()
            let freeSpaces =
                getFreeSpaces grid
                |> Array.ofList
            let food = randomFood ()
            let randomPos = freeSpaces.[random.Next(freeSpaces.Length - 1)]
            randomPos, food

        let dropFood (grid:Grid) (food:Food) =
            let (x, y), animal = food
            grid.[x].[y] <- animal

        let slither (snake:Snake<Position>) (grid:Grid) : unit =
            try
                let rec slithering (body:Snake<Position>) =
                    match body with
                    | Head(p, s) ->
                        let row, column = p
                        grid.[row].[column] <- head
                        slithering s
                    | Belly(p, s) ->
                        let row, column = p
                        grid.[row].[column] <- belly
                        slithering s
                    | Tail -> ()
                do slithering snake
            with _ -> failwith "ERROR: Could not slither snake!"

        let endGame (grid:Grid) : unit =
            Console.Clear()
            Array.iteri (fun i row ->
                Array.iteri (fun j _ ->
                    grid.[i].[j] <- errorDisplay
                ) row
            ) grid
            Array.iter (fun (row:string array) ->
                let prettyprint = String.concat "" row
                printfn $"{prettyprint}") grid
            Console.Beep()


    module GamePlay =

        let moveUp (snake:Snake<Position>) (grid:Grid) (eaten:int) (food:Food) : Game =
            match snake with
            | Head (p, rest:Snake<Position>) ->
                let x, y = p
                let shiftUp = ((x-1), y)
                try
                    match shiftUp with
                    | (row,column) when Graphics.isOccupied grid.[row].[column] ->
                        GameOver (grid, eaten)
                    | (row, column) when Graphics.isFood grid.[row].[column] ->
                        let unzipped = snakeUnzip (Head (shiftUp, (Belly (p, rest))))
                        let newSnake = snakeZip unzipped (eaten+1)
                        let nextFood = Graphics.getFood grid
                        GameRunning (Up shiftUp, newSnake, grid, eaten+1, nextFood)
                    | pivot ->
                        let unzipped = snakeUnzip (Head (pivot, (Belly (p, rest))))
                        let newSnake = snakeZip unzipped eaten
                        GameRunning (Up pivot, newSnake, grid, eaten, food)
                with _ -> GameOver (grid, eaten)
            | _ -> failwith "ERROR: No head!"

        let moveDown (snake:Snake<Position>) (grid:Grid) (eaten:int) (food:Food) : Game =
            match snake with
            | Head (p, rest:Snake<Position>) ->
                let x, y = p
                let shiftDown = ((x+1), y)
                try
                    match shiftDown with
                    | (row,column) when Graphics.isOccupied grid.[row].[column] ->
                        GameOver (grid, eaten)
                    | (row, column) when Graphics.isFood grid.[row].[column] ->
                        let unzipped = snakeUnzip (Head (shiftDown, (Belly (p, rest))))
                        let newSnake = snakeZip unzipped (eaten+1)
                        let nextFood = Graphics.getFood grid
                        GameRunning (Down shiftDown, newSnake, grid, (eaten+1), nextFood)
                    | pivot ->
                        let unzipped = snakeUnzip (Head (pivot, (Belly (p, rest))))
                        let newSnake = snakeZip unzipped eaten
                        GameRunning (Down pivot, newSnake, grid, eaten, food)
                with _ -> GameOver (grid, eaten)
            | _ -> failwith "ERROR: No head!"

        let moveLeft (snake:Snake<Position>) (grid:Grid) (eaten:int) (food:Food) : Game =
            match snake with
            | Head (p, rest:Snake<Position>) ->
                let x, y = p
                let shiftLeft = (x, (y-1))
                try
                    match shiftLeft with
                    | (row,column) when Graphics.isOccupied grid.[row].[column] ->
                        GameOver (grid, eaten)
                    | (row, column) when Graphics.isFood grid.[row].[column] ->
                        let unzipped = snakeUnzip (Head (shiftLeft, (Belly (p, rest))))
                        let newSnake = snakeZip unzipped (eaten+1)
                        let nextFood = Graphics.getFood grid
                        GameRunning (Left shiftLeft, newSnake, grid, eaten+1, nextFood)
                    | pivot ->
                        let unzipped = snakeUnzip (Head (pivot, (Belly (p, rest))))
                        let newSnake = snakeZip unzipped eaten
                        GameRunning (Left pivot, newSnake, grid, eaten, food)
                with _ -> GameOver (grid, eaten)
            | _ -> failwith "ERROR: No head!"

        let moveRight (snake:Snake<Position>) (grid:Grid) (eaten:int) (food:Food) : Game =
            match snake with
            | Head (p, rest:Snake<Position>) ->
                let (x: int), y = p
                let shiftRight = (x, (y+1))
                try
                    match shiftRight with
                    | (row,column) when Graphics.isOccupied grid.[row].[column] ->
                        GameOver (grid, eaten)
                    | (row, column) when Graphics.isFood grid.[row].[column] ->
                        let unzipped = snakeUnzip (Head (shiftRight, (Belly (p, rest))))
                        let newSnake = snakeZip unzipped (eaten+1)
                        let nextFood = Graphics.getFood grid
                        GameRunning (Right shiftRight, newSnake, grid, eaten+1, nextFood)
                    | pivot ->
                        let unzipped = snakeUnzip (Head (pivot, (Belly (p, rest))))
                        let newSnake = snakeZip unzipped eaten
                        GameRunning (Right pivot, newSnake, grid, eaten, food)
                with _ -> GameOver (grid, eaten)
            | _ -> failwith "ERROR: No head!"

open SnakeGame

[<EntryPoint>]
let main _ =

    /// A gentle slope function for making the snake go faster:
    let tick (eaten:int) = 100./log10(float eaten) |> int

    let getNextMove prev snake grid eaten food : Task<Game> =
        task {
            do! Task.Delay(tick(eaten))
            if not Console.KeyAvailable
            then
                match prev with
                    | Up _ -> return GamePlay.moveUp snake grid eaten food
                    | Down _ -> return GamePlay.moveDown snake grid eaten food
                    | Right _ -> return GamePlay.moveRight snake grid eaten food
                    | Left _ -> return GamePlay.moveLeft snake grid eaten food
                    | InvalidMove -> return GameOver (grid, eaten)
            else
                match Console.ReadKey() with
                | keystroke when keystroke.Key.Equals(ConsoleKey.UpArrow) ->
                    return GamePlay.moveUp snake grid eaten food
                | keystroke when keystroke.Key.Equals(ConsoleKey.DownArrow) ->
                    return GamePlay.moveDown snake grid eaten food
                | keystroke when keystroke.Key.Equals(ConsoleKey.RightArrow) ->
                    return GamePlay.moveRight snake grid eaten food
                | keystroke when keystroke.Key.Equals(ConsoleKey.LeftArrow) ->
                    return GamePlay.moveLeft snake grid eaten food
                | _ ->
                    match prev with
                    | Up _ -> return GamePlay.moveUp snake grid eaten food
                    | Down _ -> return GamePlay.moveDown snake grid eaten food
                    | Right _ -> return GamePlay.moveRight snake grid eaten food
                    | Left _ -> return GamePlay.moveLeft snake grid eaten food
                    | InvalidMove -> return GameOver (grid, eaten)
        }

    let gridDimension = 20
    let segments = [(0,3); (0,2); (0,1); (0,0)]
    let youngSnake : Snake<Position> = snakeZip segments segments.Length
    let startingGrid = Graphics.makeGrid gridDimension
    let startingFood = Graphics.getFood startingGrid
    let start = GamePlay.moveRight youngSnake startingGrid segments.Length startingFood

    let rec gameLoop (game:Game) =
        match game with
        | GameRunning (prev, snake, grid, eaten, food) ->
            do Graphics.clearGrid grid
            do Graphics.dropFood grid food
            do Graphics.slither snake grid
            do Graphics.render grid
            let eitherPlayerOrCursor = getNextMove prev snake grid eaten food
            do eitherPlayerOrCursor.Wait()
            gameLoop eitherPlayerOrCursor.Result
        | GameOver (grid,eaten) ->
            do Graphics.endGame grid
            printfn $"Game Over! Snake ate {eaten-segments.Length} critters!"
            do Thread.Sleep(1000)
            let rec wantToPlayAgain () =
                match Console.ReadKey() with
                | keystroke when keystroke.Key.Equals(ConsoleKey.Y)  -> gameLoop start
                | keystroke when keystroke.Key.Equals(ConsoleKey.N)  -> ()
                | _ -> wantToPlayAgain ()
            printfn $"Restart? Type Y to continue..."
            wantToPlayAgain()

    do gameLoop start
    0
