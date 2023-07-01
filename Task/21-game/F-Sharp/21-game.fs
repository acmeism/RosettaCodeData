type Player =
    | Computer
    | Person
type Play = {runningTotal:int; nextTurn:Player}
type Win =
    | ByExact of Player
    | ByOtherExceeded of Player
type Status =
    | Start
    | Playing of Play
    | Winner of Win
    | Exit

let rnd = System.Random ()
let randomFirstPlayer () =
    let selection = rnd.Next 2
    if selection = 0 then Computer else Person
let computerChose current =
    if current > 17 then 21-current // win strategy
    else if current > 13 && current < 17 then 17-current // naive thwart opponent strategy
    else rnd.Next(1, (min 4 (21-current+1)))

let (|Exact|Exceeded|Under|) i = if i = 21 then Exact else if i > 21 then Exceeded else Under
let (|ValidNumber|InvalidInput|Quit|) (s:string) =
    let trimmed = s.Trim().ToLower()
    if trimmed = "1" || trimmed = "2" || trimmed = "3" then ValidNumber
    else if trimmed = "q" then Quit
    else InvalidInput

let readable = function | Computer -> "Computer is" | Person -> "You are"

let rec looper = function
    | Start ->
        let firstPlayer = randomFirstPlayer ()
        printfn $"{readable firstPlayer} randomly selected to go first."
        looper (Playing {runningTotal=0; nextTurn=firstPlayer})
    | Playing play ->
        match play with
        | {runningTotal=Exact; nextTurn=Person} -> looper (Winner (ByExact Computer))
        | {runningTotal=Exact; nextTurn=Computer} -> looper (Winner (ByExact Person))
        | {runningTotal=Exceeded; nextTurn=player} -> looper (Winner (ByOtherExceeded player))
        | {runningTotal=r; nextTurn=player} ->
            match player with
            | Computer ->
                let computerChoice = computerChose r
                let total = r+computerChoice
                printfn $"Computer entered {computerChoice}. Current total now: {total}."
                looper (Playing {runningTotal=total; nextTurn=Person})
            | Person ->
                let input = printf "Enter number 1, 2, or 3 (or q to exit): "; System.Console.ReadLine ()
                match input with
                | ValidNumber ->
                    let playerChoice = System.Int32.Parse input
                    let total = r+playerChoice
                    printfn $"Player entered {playerChoice}. Current total now: {total}."
                    looper (Playing {runningTotal=total; nextTurn=Computer})
                | Quit -> looper Exit
                | InvalidInput -> printfn "Invalid input. Try again."; looper (Playing play)
    | Winner win ->
        match win with
        | ByExact player -> printfn $"{readable player} the winner by getting to 21."; looper Exit
        | ByOtherExceeded player -> printfn $"{readable player} the winner by not exceeding 21."; looper Exit
    | Exit -> printfn "Thanks for playing!"

let run () = looper Start
