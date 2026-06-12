// Changeable words: Nigel Galloway. June 14th., 2021
let     fN   g=Seq.fold2(fun z n g->z+if n=g then 0 else 1) 0 g
let rec fG n g=match g with h::t->fG(n@(t|>List.choose(fun g->match fN g h with 1->Some(h,g)|_->None))) t|_->n
seq{use n=System.IO.File.OpenText("unixdict.txt") in while not n.EndOfStream do yield n.ReadLine()}|>Seq.filter(fun n->n.Length>11)
  |>List.ofSeq|>List.groupBy(fun n->n.Length)|>Seq.collect(fun(_,n)->fG [] n)|>Seq.iter(fun(n,g)->printfn "%s <=> %s" n g)
