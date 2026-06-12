let rnd=System.Random()
let sottolo(n:int[])=let rec fN g=match g with -1|0->() |_->let e=rnd.Next(g-1) in let l=n.[g] in n.[g]<-n.[e]; n.[e]<-l; fN (g-1) in fN((Array.length n)-1)
[[||];[|10|];[|10;20|];[|10;20;30|];[|11..22|]]|>List.iter(fun n->printf "%A->" n; sottolo n; printfn "%A" n)
