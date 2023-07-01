let rnd = System.Random()
let shuffled min max =
    [|min..max|] |> Array.sortBy (fun _ -> rnd.Next(min,max+1))

let drawers () = shuffled 1 100

// strategy randomizing drawer opening
let badChoices (drawers' : int array) =
    Seq.init 100 (fun _ -> shuffled 1 100 |> Array.take 50) // selections for each prisoner
    |> Seq.map (fun indexes -> indexes |> Array.map(fun index -> drawers'.[index-1])) // transform to cards
    |> Seq.mapi (fun i cards -> cards |> Array.contains i) // check if any card matches prisoner number
    |> Seq.contains false // true means not all prisoners got their cards
let outcomeOfRandom runs =
    let pardons = Seq.init runs (fun _ -> badChoices (drawers ()))
                  |> Seq.sumBy (fun badChoice -> if badChoice |> not then 1.0 else 0.0)
    pardons/ float runs

// strategy optimizing drawer opening
let smartChoice max prisoner (drawers' : int array) =
    prisoner
    |> Seq.unfold (fun selection ->
        let card = drawers'.[selection-1]
        Some (card, card))
    |> Seq.take max
    |> Seq.contains prisoner
let smartChoices (drawers' : int array) =
    seq { 1..100 }
    |> Seq.map (fun prisoner -> smartChoice 50 prisoner drawers')
    |> Seq.filter (fun result -> result |> not) // remove all but false results
    |> Seq.isEmpty // empty means all prisoners got their cards
let outcomeOfOptimize runs =
    let pardons = Seq.init runs (fun _ -> smartChoices (drawers()))
                  |> Seq.sumBy (fun smartChoice' -> if smartChoice' then 1.0 else 0.0)
    pardons/ float runs

printfn $"Using Random Strategy: {(outcomeOfRandom 20000):p2}"
printfn $"Using Optimum Strategy: {(outcomeOfOptimize 20000):p2}"
