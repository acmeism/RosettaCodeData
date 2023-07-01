// Dinesman's multiple-dwelling. Nigel Galloway: September 23rd., 2020
type names = |Baker=0 |Cooper=1 |Miller=2 |Smith=3 |Fletcher=4
let fN=Ring.PlainChanges [|for n in System.Enum.GetValues(typeof<names>)->n:?>names|]
let fG n g l=n|>Array.pairwise|>Array.forall(fun n->match n with (n,i) when (n=g && i=l)->false |(i,n) when (n=g && i=l)->false |_->true)
fN|>Seq.filter(fun n->n.[4]<>names.Baker && n.[0]<>names.Cooper && n.[0]<>names.Fletcher && n.[4]<>names.Fletcher && fG n names.Smith names.Fletcher
                      && fG n names.Cooper names.Fletcher && (Array.findIndex((=)names.Cooper) n) < (Array.findIndex((=)names.Miller) n))
  |>Seq.iter(Array.iteri(fun n g->printfn "%A lives on floor %d" g n))
