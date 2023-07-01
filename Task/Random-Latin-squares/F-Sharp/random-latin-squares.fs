// Generate 2 Random Latin Squares of order 5. Nigel Galloway: July 136th., 2019
let N=let N=System.Random() in (fun n->N.Next(n))
let rc()=let β=lN2p [|0;N 4;N 3;N 2|] [|0..4|] in Seq.item (N 56) (normLS 5) |> List.map(lN2p [|N 5;N 4;N 3;N 2|]) |> List.permute(fun n->β.[n]) |> List.iter(printfn "%A")
rc(); printfn ""; rc()
