// I provide four functions:-
// cf2S general purpose continued fraction to sequence of float approximations
// cN2S Normal continued fractions (a-series always 1)
// cfSqRt uses cf2S to calculate sqrt of float
// π takes a sequence of b values returning the next until the list is exhausted after which  it injects infinity
// Nigel Galloway: December 19th., 2018
let cf2S α β=let n0,g1,n1,g2=β(),α(),β(),β()
             seq{let (Π:decimal)=g1/n1 in yield n0+Π; yield! Seq.unfold(fun(n,g,Π)->let a,b=α(),β() in let Π=Π*g/n in Some(n0+Π,(b+a/n,b+a/g,Π)))(g2+α()/n1,g2,Π)}
let cN2S = cf2S (fun()->1M)
let cfSqRt n=(cf2S (fun()->n-1M) (let mutable n=false in fun()->if n then 2M else (n<-true; 1M)))
let π n=let mutable π=n in (fun ()->match π with h::t->π<-t; h |_->9999999999999999999999999999M)
