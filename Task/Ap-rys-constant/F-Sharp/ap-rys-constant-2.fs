let cf2br α β=let n0,g1,n1,g2=β(),α(),β(),β()
              seq{let (Π:BigRational)=g1/n1 in yield n0+Π; yield! Seq.unfold(fun(n,g,Π)->let a,b=α(),β() in let Π=Π*g/n in Some(n0+Π,(b+a/n,b+a/g,Π)))(g2+α()/n1,g2,Π)}
let aπ()=let mutable n=0N in (fun ()->n<-n+1N; -(BigRational.Pow(n,6)))
let bπ()=let mutable n=0N in (fun ()->n<-n+1N; (2N*n-1N)*(17N*n*n-17N*n+5N))
cf2br (aπ()) (bπ())|>Seq.skip 31|>Seq.take 1|>Seq.iter(fun n->let n=6N/n in let n,g=fG (n.Numerator) (n.Denominator) 100 in printf $"%d{n}."; g|>Seq.iter(printf "%d"); printfn "")
