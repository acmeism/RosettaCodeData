let m n = Seq.unfold(fun i -> Some(bigint.Pow(i, n), i + 1I)) 0I

let squares = m 2
let cubes = m 3

let (--) orig veto = Seq.where(fun n -> n <> (Seq.find(fun m -> m >= n) veto)) orig

let ``squares without cubes`` = squares -- cubes

Seq.take 10 (Seq.skip 20 (``squares without cubes``))
|> Seq.toList |> printfn "%A"
