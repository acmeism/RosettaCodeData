// Odd and square numbers. Nigel Galloway: November 23rd., 2021
Seq.initInfinite((*)2>>(+)11)|>Seq.map(fun n->n*n)|>Seq.takeWhile((>)1000)|>Seq.iter(printfn "%d")
