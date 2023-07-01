let isSemiprime (n: int) =
    let rec loop currentN candidateFactor numberOfFactors =
        if numberOfFactors > 2 then numberOfFactors
        elif currentN = candidateFactor then numberOfFactors+1
        elif currentN % candidateFactor = 0 then loop (currentN/candidateFactor) candidateFactor (numberOfFactors+1)
        else loop currentN (candidateFactor+1) numberOfFactors
    if n < 2 then false else 2 = loop n 2 0

seq { 1 .. 100 } |> Seq.choose (fun n -> if isSemiprime n then Some(n) else None)
|> Seq.toList |> printfn "%A"

seq { 1675 .. 1680 }
|> Seq.choose (fun n -> if isSemiprime n then Some(n) else None)
|> Seq.toList
|> printfn "%A"
