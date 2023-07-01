(* Since the task description here does not impose Dijsktra's original restrictions
    * Changing the order is only allowed by swapping 2 elements
    * Every element must only be inspected once
   we have several options ...
   One way -- especially when we work with immutable data structures --
   is to scan the unordered list, collect the different
   colours on our way and append the 3 sub-lists in the correct order.
*)
let rnd = System.Random()

type color = | Red | White | Blue

let isDutch s =
    Seq.forall2 (fun last this ->
        match (last, this) with
        | (Red, Red) | (Red, White) | (White, White) | (White, Blue) | (Blue, Blue) -> true | _ -> false
    ) s (Seq.skip 1 s)

[<EntryPoint>]
let main argv =
    let n = 10
    let rec getBallsToSort n s =
        let sn = Seq.take n s
        if (isDutch sn) then (getBallsToSort n (Seq.skip 1 s)) else sn
    let balls = getBallsToSort n (Seq.initInfinite (fun _ -> match (rnd.Next(3)) with | 0 -> Red | 1 -> White | _ -> Blue))
    printfn "Sort the sequence of %i balls: %A" n (Seq.toList balls)
    let (rs,ws,bs) =
        balls
        |> Seq.fold (fun (rs,ws,bs) b ->
            match b with | Red -> (b::rs,ws,bs) | White -> (rs,b::ws,bs) | Blue -> (rs,ws,b::bs))
            ([],[],[])
    let sorted = rs @ ws @ bs
    printfn "The sequence %A is sorted: %b" sorted (isDutch sorted)
    0
