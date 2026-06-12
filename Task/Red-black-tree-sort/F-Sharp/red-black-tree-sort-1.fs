// Red black tree sort. Nigel Galloway: June 17th., 2022
let fromSeq n=n|>Seq.fold(fun n g->insert g n) Empty
let toSeq g=let rec fN g=seq{match g with N(i,g,e,l)->yield l; yield! fN g; yield! fN e |_->()} in fN g
let delSeq n g=toSeq g|>Seq.except n|>fromSeq
let rec printN n s t=match n with N(i,g,e,l)->printN g (s+"    ") "L";printfn "%s %s %A %d" s t i l; printN e (s+"    ") "R" |_->()
