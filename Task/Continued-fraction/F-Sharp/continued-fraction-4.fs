let aπ()=let mutable n=0M in (fun ()->n<-n+1M;let b=n+n-1M in b*b)
let bπ()=let mutable n=true in (fun ()->match n with true->n<-false;3M |_->6M)
cf2S (aπ()) (bπ()) |> Seq.take 10 |> Seq.pairwise |> Seq.iter(fun(n,g)->printfn "%1.14f < π < %1.14f" (min n g) (max n g))
