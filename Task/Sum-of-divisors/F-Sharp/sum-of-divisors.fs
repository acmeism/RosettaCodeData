// Sum of divisors. Nigel Galloway: March 9th., 2021
let sod u=let P=primes32()
          let rec fN g=match u%g with 0->g |_->fN(Seq.head P)
          let rec fG n i g e l=match n=u,u%l with (true,_)->e*g |(_,0)->fG (n*i) i g (e+l)(l*i) |_->let q=fN(Seq.head P) in fG n q (g*e) 1 q
          let n=Seq.head P in fG 1 n 1 1 n
[1..100]|>Seq.iter(sod>>printf "%d "); printfn ""
