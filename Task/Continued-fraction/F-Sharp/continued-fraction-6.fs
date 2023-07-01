let ae()=let mutable n=0.5M in (fun ()->match n with 0.5M->n<-0M; 1M |_->n<-n+1M; n)
let be()=let mutable n=0.5M in (fun ()->match n with 0.5M->n<-0M; 2M |_->n<-n+1M; n)
cf2S (ae()) (be()) |> Seq.take 10 |> Seq.pairwise |> Seq.iter(fun(n,g)->printfn "%1.14f < e < %1.14f" (min n g) (max n g))
