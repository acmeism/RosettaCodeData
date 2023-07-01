let fN=let mutable n=0 in (fun (_,g)->if g>=n then n<-pown 10 (string g).Length; true else false)
fusc |> Seq.filter fN |> Seq.take 7 |> Seq.iter(fun(n,g)->printfn "fusc %d -> %d" n g)
