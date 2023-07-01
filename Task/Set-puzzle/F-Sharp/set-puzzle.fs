open System

type Number = One | Two | Three
type Color = Red | Green | Purple
type Fill = Solid | Open | Striped
type Symbol = Oval | Squiggle | Diamond

type Card = { Number: Number; Color: Color; Fill: Fill; Symbol: Symbol }

// A 'Set' is 3 cards in which each individual feature is either all the SAME on each card, OR all DIFFERENT on each card.
let SetSize = 3

type CardsGenerator() =
    let _rand = Random()

    let shuffleInPlace data =
        Array.sortInPlaceBy (fun _ -> (_rand.Next(0, Array.length data))) data

    let createCards() =
        [| for n in [One; Two; Three] do
                for c in [Red; Green; Purple] do
                    for f in [Solid; Open; Striped] do
                        for s in [Oval; Squiggle; Diamond] do
                            yield { Number = n; Color = c; Fill = f; Symbol = s } |]

    let _cards = createCards()

    member x.GetHand cardCount =
        shuffleInPlace _cards
        Seq.take cardCount _cards |> Seq.toList

// Find all the combinations of n elements
let rec combinations n items =
    match n, items with
    | 0, _  -> [[]]
    | _, [] -> []
    | k, (x::xs) -> List.map ((@) [x]) (combinations (k-1) xs) @ combinations k xs

let validCardSet (cards: Card list) =
    // Valid feature if all features are the same or different
    let validFeature = function
        | [a; b; c] -> (a = b && b = c) || (a <> b && a <> c && b <> c)
        | _ -> false

    // Build and validate the feature lists
    let isValid = cards |> List.fold (fun (ns, cs, fs, ss) c ->
                               (c.Number::ns, c.Color::cs, c.Fill::fs, c.Symbol::ss)) ([], [], [], [])
                        |> fun (ns, cs, fs, ss) ->
                               (validFeature ns) && (validFeature cs) && (validFeature fs) && (validFeature ss)

    if isValid then Some cards else None

let findSolution cardCount setCount =
    let cardsGen = CardsGenerator()

    let rec search () =
        let hand = cardsGen.GetHand cardCount
        let foundSets = combinations SetSize hand |> List.choose validCardSet

        if foundSets.Length = setCount then (hand, foundSets) else search()

    search()

let displaySolution (hand: Card list, sets: Card list list) =
    let printCardDetails (c: Card) =
        printfn "    %A %A %A %A" c.Number c.Color c.Symbol c.Fill

    printfn "Dealt %d cards:" hand.Length
    List.iter printCardDetails hand
    printf "\n"

    printfn "Found %d sets:" sets.Length
    sets |> List.iter (fun cards -> List.iter printCardDetails cards; printf "\n" )

let playGame() =
    let solve cardCount setCount =
        displaySolution (findSolution cardCount setCount)

    solve 9 4
    solve 12 6

playGame()
