// Strand sort. Nigel Galloway: August 18th., 2023
let     fN g=let mutable n=g in fun g->if n>g then false else n<-g; true
let     fI n=let fN=fN(List.head n) in List.partition fN n
let rec fG n g=[match n,g with [],g|g,[]->yield! g
                              |n::gn,i::ng when n<i->yield n; yield! fG gn g
                              |n,g::ng->yield g; yield! fG n ng]
let rec fL n g=match n with []->g |_->let n,i=fI n in fL i (n::g)
let sort n=fL n []|>List.fold(fun n g->fG n g)[]
printfn "%A" (sort ["one";"two";"three";"four"]);;
printfn "%A" (sort [2;3;1;5;11;7;5])
