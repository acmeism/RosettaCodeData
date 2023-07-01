// Factorial base numbers indexing permutations of a collection
// Nigel Galloway: December 7th., 2018
let lN2p (c:int[]) (Ω:'Ω[])=
  let Ω=Array.copy Ω
  let rec fN i g e l=match l-i with 0->Ω.[i]<-e |_->Ω.[l]<-Ω.[l-1]; fN i g e (l-1)// rotate right
  [0..((Array.length Ω)-2)]|>List.iter(fun n->let i=c.[n] in if i>0 then fN n (i+n) Ω.[i+n] (i+n)); Ω
let lN n =
  let    Ω=(Array.length n)
  let fN g=if n.[g]=Ω-g then n.[g]<-0; false else n.[g]<-n.[g]+1; true
  seq{yield n; while [1..Ω]|>List.exists(fun g->fN (Ω-g)) do yield n}
