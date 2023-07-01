// Integer exponentiation using Knuth power tree. Nigel Galloway: October 29th., 2020
let kT α=let n=Array.zeroCreate<int*int list>((pown 2 (α+1))+1)
         let fN g=let rec fN p=[yield g+p; if p>0 then let g,_=n.[p] in yield! fN g] in (g+g)::(fN (fst n.[g]))|>List.rev
         let fG g=[for α,β in g do for g in β do let p,_=n.[g] in n.[g]<-(p,fN g|>List.filter(fun β->if box n.[β]=null then n.[β]<-(g,[]); true else false)); yield n.[g]]
         let rec kT n g=match g with 0->() |_->let n=fG n in kT n (g-1)
         let fE X g=let α=let rec fE g=[|yield g; if g>1 then yield! fE (fst n.[g])|] in fE g
                    let β=Array.zeroCreate<bigint>α.Length
                    let l=β.Length-1
                    β.[l]<-bigint (X+0)
                    for e in l-1.. -1..0 do β.[e]<-match α.[e]%2 with 0->β.[e+1]*β.[e+1] |_->let l=α.[e+1] in β.[e+1]*β.[α|>Array.findIndex(fun n->l+n=α.[e])]
                    β.[0]
         n.[1]<-(0,[2]); n.[2]<-(1,[]); kT [n.[1]] α; (fun n g->if g=0 then 1I else fE n g)
let xp=kT 11
[0..17]|>List.iter(fun n->printfn "2**%d=%A\n" n (xp 2 n))
printfn "3**191=%A" (xp 3 191)
