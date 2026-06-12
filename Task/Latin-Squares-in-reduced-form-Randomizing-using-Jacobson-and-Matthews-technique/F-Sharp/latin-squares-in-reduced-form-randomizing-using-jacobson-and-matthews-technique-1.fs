// Jacobson and Matthews technique for generating Latin Squares. Nigel Galloway: August 5th., 2019
let R=let N=System.Random() in (fun n->N.Next(n))

let jmLS α X0=
  let X0=Array2D.copy X0
  let N=let N=[|[0..α-1];[α-1..(-1)..0]|] in (fun()->N.[R 2])
  let rec randLS i j z n g s=
    X0.[i,g]<-s; X0.[n,j]<-s
    if X0.[n,g]=s then X0.[n,g]<-z; X0
    else randLS n g s (List.find(fun n->X0.[n,g]=s)(N())) (List.find(fun g->X0.[n,g]=s)(N())) (if (R 2)=0 then let t=X0.[n,g] in X0.[n,g]<-z; t else z)
  let i,j=R α,R α
  let z  =let z=1+(R (α-1)) in if z<X0.[i,j] then z else 1+(z+1)%α
  let n,g,s=let N=[0..α-1] in (List.find(fun n->X0.[n,j]=z) N,List.find(fun n->X0.[i,n]=z) N,X0.[i,j])
  X0.[i,j]<-z; randLS i j z n g s

let asNormLS α=
  let n=Array.init (Array2D.length1 α) (fun n->(α.[n,0]-1,n))|>Map.ofArray
  let g=Array.init (Array2D.length1 α) (fun g->(α.[n.[0],g]-1,g))|>Map.ofArray
  Array2D.init (Array2D.length1 α) (Array2D.length1 α) (fun i j->α.[n.[i],g.[j]])

let randLS α=Seq.unfold(fun g->Some(g,jmLS α g))(Array2D.init α α (fun n g->1+(n+g)%α))
