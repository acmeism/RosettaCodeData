// Generate Mian-Chowla sequence. Nigel Galloway: March 23rd., 2019
let mC=let rec fN i g l=seq{
         let a=(l*2)::[for i in i do yield i+l]@g
         let b=[l+1..l*2]|>Seq.find(fun e->Seq.forall(fun g->(Seq.contains (g-e)>>not) i) a)
         yield b; yield! fN (l::i) (a|>List.filter(fun n->n>b)) b}
       seq{yield 1; yield! fN [] [] 1}
