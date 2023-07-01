open System

let generate_number targetSize =
    let rnd = Random()
    let initial = Seq.initInfinite (fun _ -> rnd.Next(1,9))
    initial |> Seq.distinct |> Seq.take(targetSize) |> Seq.toList

let countBulls guess target =
    let hits = List.map2 (fun g t -> if g = t then true else false) guess target
    List.filter (fun x -> x = true) hits |> List.length

let countCows guess target =
    let mutable score = 0
    for g in guess do
        for t in target do
            if g = t then
                score <- score + 1
            else
                score <- score
    score

let countScore guess target =
    let bulls = countBulls guess target
    let cows = countCows guess target
    (bulls, cows)

let playRound guess target =
    countScore guess target

let inline ctoi c : int =
    int c - int '0'

let lineToList (line: string) =
    let listc = Seq.map(fun c -> c |> string) line |> Seq.toList
    let conv = List.map(fun x -> Int32.Parse x) listc
    conv

let readLine() =
    let line = Console.ReadLine()
    if line <> null then
        if line.Length = 4 then
            Ok (lineToList line)
        else
            Error("Input guess must be 4 characters!")
    else
        Error("Input guess cannot be empty!")

let rec handleInput() =
    let line = readLine()
    match line with
    | Ok x -> x
    | Error s ->
        printfn "%A" s
        handleInput()

[<EntryPoint>]
let main argv =
    let target = generate_number 4
    let mutable shouldEnd = false
    while shouldEnd = false do
        let guess = handleInput()
        let (b, c) = playRound guess target
        printfn "Bulls: %i | Cows: %i" b c
        if b = 4 then
            shouldEnd <- true
        else
            shouldEnd <- false
    0
