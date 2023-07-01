// A296712. Nigel Galloway: October 9th., 2020
let fN g=let rec fN Ψ n g=match n,Ψ with (0,0)->true |(0,_)->false |_->let i=n%10 in fN (Ψ + (compare i g)) (n/10) i in fN 0 g (g%10)
let A296712=seq{1..2147483647}|>Seq.filter fN
A296712|>Seq.take 200|>Seq.iter(printf "%d "); printfn"\n"
[999999;9999999;99999999]|>List.iter(fun n->printfn "The %dth element is %d" (n+1) (Seq.item n A296712))
