let rec iterate f value = seq {
    yield value
    yield! iterate f (f value) }

let up i = i + 1
let right i = i
let down i = i - 1

let noCollisionGivenDir solution number dir =
    Seq.forall2 (<>) solution (Seq.skip 1 (iterate dir number))

let goodAddition solution number =
    List.forall (noCollisionGivenDir solution number) [ up; right; down ]

let rec extendSolution n ps =
    [0..n - 1]
    |> List.filter (goodAddition ps)
    |> List.map (fun num -> num :: ps)

let allSolutions n =
    iterate (List.collect (extendSolution n)) [[]]

// Print one solution for the 8x8 case
let printOneSolution () =
    allSolutions 8
    |> Seq.item 8
    |> Seq.head
    |> List.iter (fun rowIndex ->
        printf "|"
        [0..8] |> List.iter (fun i -> printf (if i = rowIndex then "X|" else " |"))
        printfn "")

// Print number of solution for the other cases
let printNumberOfSolutions () =
    printfn "Size\tNr of solutions"
    [1..11]
    |> List.map ((fun i -> Seq.item i (allSolutions i)) >> List.length)
    |> List.iteri (fun i cnt -> printfn "%d\t%d" (i+1) cnt)

printOneSolution()

printNumberOfSolutions()
