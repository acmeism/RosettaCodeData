// Count Zigzag numbers. Nigel Galloway: September 12th., 2025
let N=100 in let G=Array2D.create<bigint option> (N+1) (N+1) None
G[0,0]<-Some(1I); for n in 1..N-1 do G[n,0]<-Some(0I)
let rec fG n g=match G[n,g] with Some n->n
                                |_->G[n,g]<-Some(fG n (g-1)+fG (n-1) (n-g)); G[n,g].Value
let zigN g=[1..g-1]|>List.sumBy(fun n->fG (g-1) n)
for n in 2..N do printfn "%d->%A" n (zigN n)
