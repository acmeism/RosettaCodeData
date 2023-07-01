// Pseudo-random numbers/Middle-square method. Nigel Galloway: January 5th., 2022
Seq.unfold(fun n->let n=n*n%1000000000L/1000L in Some(n,n)) 675248L|>Seq.take 5|>Seq.iter(printfn "%d")
