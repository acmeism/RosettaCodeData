let rec genFactor (f, n) =
    if f > n then None
    elif n % f = 0 then Some (f, (f, n/f))
    else genFactor (f+1, n)


let factorsOf (num) =
    Seq.unfold (fun (f, n) -> genFactor (f, n)) (2, num)

let kFactors k = Seq.unfold (fun n ->
    let rec loop m =
        if Seq.length (factorsOf m) = k then m
        else loop (m+1)
    let next = loop n
    Some(next, next+1)) 2

[1 .. 5]
|> List.iter (fun k ->
        printfn "%A" (Seq.take 10 (kFactors k) |> Seq.toList))
