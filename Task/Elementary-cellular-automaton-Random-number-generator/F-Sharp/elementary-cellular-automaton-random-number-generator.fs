// Generate random numbers using Rule 30. Nigel Galloway: August 1st., 2019
eca 30 [|yield 1; yield! Array.zeroCreate 99|]|>Seq.chunkBySize 8|>Seq.map(fun n->n|>Array.mapi(fun n g->g.[0]<<<(7-n))|>Array.sum)|>Seq.take 10|>Seq.iter(printf "%d "); printfn ""
