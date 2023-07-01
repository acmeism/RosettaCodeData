// Nigel Galloway: May 30th., 2019
let fN n g=let g=n|>Array.rev|>Array.mapi(fun i n->(int64 n)*(pown g i))|>Array.sum
           let n=int64(sqrt (float g)) in g=(n*n)
let fG g=lN([|yield 1; yield! Array.zeroCreate(g-2)|])|>Seq.map(fun n->lN2p n [|0..(g-1)|]) |> Seq.filter(fun n->fN n (int64 g))
printfn "%A" (fG 12|>Seq.head) // -> [|1; 2; 4; 10; 7; 11; 5; 3; 8; 6; 0; 9|]
printfn "%A" (fG 14|>Seq.head) // -> [|1; 0; 2; 6; 9; 11; 8; 12; 5; 7; 13; 3; 10; 4|]
