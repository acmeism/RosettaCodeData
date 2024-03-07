// Wireworld. Nigel Galloway: January 22nd., 2024
type Cell= |E |T |H |C
let n=array2D [[T;H;C;C;C;C;C;C;C;C;C];
               [C;E;E;E;C;E;E;E;E;E;E];
               [E;E;E;C;C;C;E;E;E;E;E];
               [C;E;E;E;C;E;E;E;E;E;E];
               [H;T;C;C;E;C;C;C;C;C;C]]
let fG n g=match n|>Seq.sumBy(fun n->match Array2D.get g (fst n) (snd n) with H->1 |_->0) with 1 |2->H |_->C
let fX i=i|>Array2D.mapi(fun n g->function |E->E |H->T |T->C |C->fG (Seq.allPairs [max 0 (n-1)..min (n+1) (Array2D.length1 i-1)] [max 0 (g-1)..min (g+1) (Array2D.length2 i-1)]) i)
Seq.unfold(fun n->Some(n,fX n))n|>Seq.take 15|>Seq.iteri(fun n g->printfn "%d:\n%A\n" n g)
