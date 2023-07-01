open System;
open System.Drawing;
open System.Diagnostics;

let Length (seg : (PointF * PointF) option) =
    match seg with
    | None -> System.Single.MaxValue
    | Some(line) ->
        let f = fst line
        let t = snd line

        let dx = f.X - t.X
        let dy = f.Y - t.Y
        sqrt (dx*dx + dy*dy)


let Shortest a b =
    if Length(a) < Length(b) then
        a
    else
        b


let rec ClosestBoundY from maxY (ptsByY : PointF list) =
    match ptsByY with
    | [] -> None
    | hd :: tl ->
        if hd.Y > maxY then
            None
        else
            let toHd = Some(from, hd)
            let bestToRest = ClosestBoundY from maxY tl
            Shortest toHd bestToRest


let rec ClosestWithinRange ptsByY maxDy =
    match ptsByY with
    | [] -> None
    | hd :: tl ->
        let fromHd = ClosestBoundY hd (hd.Y + maxDy) tl
        let fromRest = ClosestWithinRange tl  maxDy
        Shortest fromHd fromRest


// Cuts pts half way through it's length
// Order is not maintained in result lists however
let Halve pts =
    let rec ShiftToFirst first second n =
        match (n, second) with
        | 0, _ -> (first, second)   // finished the split, so return current state
        | _, [] -> (first, [])      // not enough items, so first takes the whole original list
        | n, hd::tl -> ShiftToFirst (hd :: first) tl (n-1)  // shift 1st item from second to first, then recurse with n-1

    let n = (List.length pts) / 2
    ShiftToFirst [] pts n


let rec ClosestPair (pts : PointF list) =
    if List.length pts < 2 then
        None
    else
        let ptsByX = pts |> List.sortBy(fun(p) -> p.X)

        let (left, right) = Halve ptsByX
        let leftResult = ClosestPair left
        let rightResult = ClosestPair right

        let bestInHalf = Shortest  leftResult rightResult
        let bestLength = Length bestInHalf

        let divideX = List.head(right).X
        let inBand = pts |> List.filter(fun(p) -> Math.Abs(p.X - divideX) < bestLength)

        let byY = inBand |> List.sortBy(fun(p) -> p.Y)
        let bestCross = ClosestWithinRange byY bestLength
        Shortest bestInHalf bestCross


let GeneratePoints n =
    let rand = new Random()
    [1..n] |> List.map(fun(i) -> new PointF(float32(rand.NextDouble()), float32(rand.NextDouble())))

let timer = Stopwatch.StartNew()
let pts = GeneratePoints (50 * 1000)
let closest = ClosestPair pts
let takenMs = timer.ElapsedMilliseconds

printfn "Closest Pair '%A'.  Distance %f" closest (Length closest)
printfn "Took %d [ms]" takenMs
