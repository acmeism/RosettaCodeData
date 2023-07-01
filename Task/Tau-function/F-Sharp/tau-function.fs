// Tau function. Nigel Galloway: March 10th., 2021
let tau u=let P=primes32()
          let rec fN g=match u%g with 0->g |_->fN(Seq.head P)
          let rec fG n i g e l=match n=u,u%l with (true,_)->e |(_,0)->fG (n*i) i g (e+g)(l*i) |_->let q=fN(Seq.head P) in fG (n*q) q e (e+e) (q*q)
          let n=Seq.head P in fG 1 n 1 1 n
[1..100]|>Seq.iter(tau>>printf "%d "); printfn ""
