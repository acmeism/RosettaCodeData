// Abelian sandpile model. Nigel Galloway: July 20th., 2020
type Sandpile(x,y,N:int[])=
  member private this.x=x
  member private this.y=y
  member private this.i=let rec topple n=match Array.tryFindIndex(fun n->n>3)n with
                                          None->n
                                         |Some g->let i=n.[g]/4
                                                  n.[g]<-n.[g]%4
                                                  match g%x,g/x with
                                                   (0,0)->n.[x]<-n.[x]+i;n.[1]<-n.[1]+i;topple n
                                                  |(α,0) when α=x-1->n.[g+x]<-n.[g+x]+i;n.[g-1]<-n.[g-1]+i;topple n
                                                  |(_,0)->n.[g-1]<-n.[g-1]+i;n.[g+1]<-n.[g+1]+i;n.[g+x]<-n.[g+x]+i;topple n
                                                  |(0,β) when β=y-1->n.[g-x]<-n.[g-x]+i;n.[g+1]<-n.[g+1]+i;topple n
                                                  |(0,β)->n.[g-x]<-n.[g-x]+i;n.[g+1]<-n.[g+1]+i;n.[g+x]<-n.[g+x]+i;topple n
                                                  |(α,β) when α=x-1 && β=y-1->n.[g-1]<-n.[g-1]+i;n.[g-x]<-n.[g-x]+i;topple n
                                                  |(α,_) when α=x-1->n.[g-1]<-n.[g-1]+i;n.[g-x]<-n.[g-x]+i;n.[g+x]<-n.[g+x]+i;topple n
                                                  |(_,β) when β=y-1->n.[g-1]<-n.[g-1]+i;n.[g-x]<-n.[g-x]+i;n.[g+1]<-n.[g+1]+i;topple n
                                                  |_->n.[g-1]<-n.[g-1]+i;n.[g-x]<-n.[g-x]+i;n.[g+x]<-n.[g+x]+i;n.[g+1]<-n.[g+1]+i;topple n
                        topple N
  static member (+) (n:Sandpile, g:Sandpile)=Sandpile(n.x,n.y,Array.map2(fun n g->n+g) n.i g.i)
  member this.toS=sprintf "%A" (this.i|>Array.chunkBySize x|>array2D)

printfn "%s\n" (Sandpile(3,3,[|4;3;3;3;1;2;0;2;3|])).toS
let e1=Array.zeroCreate<int> 25 in e1.[12]<-4; printfn "%s\n" (Sandpile(5,5,e1)).toS
let e1=Array.zeroCreate<int> 25 in e1.[12]<-6; printfn "%s\n" (Sandpile(5,5,e1)).toS
let e1=Array.zeroCreate<int> 25 in e1.[12]<-16; printfn "%s\n" (Sandpile(5,5,e1)).toS
