// Upside-down numbers. Nigel Galloway: September 2nd., 2024
let rec f9 n g l=if n=0I then g else let a,b=bigint.DivRem(n,9I) in f9 a (g+b*10I**l) (l+1)
let fD i=let rec fG n g=let t=g+9I**(n/2) in if t>i then(n,f9 (i-g-1I) 0I 0 + (10I**(n/2)-1I)/9I) else fG (n+1) t in fG 1 0I
let rec fN n g=if n=0I then g else let a,b=bigint.DivRem(n,10I) in fN a (g*10I+10I-b)
let     fG n g=let i=fN g 0I in if n%2=0 then g*10I**(n/2)+i else (g*10I+5I)*10I**(n/2)+i
let udn n=match fD n with _,n when n=0I->5I |n,g when g%10I=0I->fG n (10I**((n-1)/2)-1I) |n,g->fG n g

[1I..50I]|>Seq.iter(udn>>printf "%A "); printfn "\n"
[182I;500I;910I;911I]|>Seq.iter(fun n->printfn "%A -> %A" n (udn n)); printfn ""
Seq.unfold(fun n->Some(n,n*10I))5000I|>Seq.take 13|>Seq.iter(fun n->printfn "%A -> %A" n (udn n)); printfn ""
let n=10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001I in printfn "I suppose I must\n%A -> %A" n (udn n)
