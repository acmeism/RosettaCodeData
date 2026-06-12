// Shape-Machine. Nigel Galloway: July 22nd., 2024
let r=System.Random()
let n=Seq.unfold(fun x->Some(x,(x+3.0)*0.86))(r.NextDouble()* -100.0)|>Seq.pairwise|>Seq.takeWhile(fun(n,g)->n<>g)
printfn "starting with %.50f produces %.50f after %d iterations" (fst(Seq.head n)) (fst(Seq.last n)) (Seq.length n)
