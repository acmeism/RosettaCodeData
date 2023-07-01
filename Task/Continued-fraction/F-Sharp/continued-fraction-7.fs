let aπ()=let mutable n=0 in (fun ()->n<-n+1;-decimal(pown n 6))
let bπ()=let mutable n=0M in (fun ()->n<-n+1M; (2M*n-1M)*(17M*n*n-17M*n+5M))
cf2S (aπ()) (bπ()) |>Seq.map(fun n->6M/n) |> Seq.take 10 |> Seq.pairwise |> Seq.iter(fun(n,g)->printfn "%1.20f < p < %- 1.20f" (min n g) (max n g));;
