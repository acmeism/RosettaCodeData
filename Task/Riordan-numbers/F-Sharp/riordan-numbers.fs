// Riordan numbers. Nigel Galloway: August 19th., 2022
let r()=seq{yield 1I; yield 0I; yield! Seq.unfold(fun(n,n1,n2)->let r=(n-1I)*(2I*n1+3I*n2)/(n+1I) in Some(r,(n+1I,r,n1)))(2I,0I,1I)}
let n=r()|>Seq.take 10000|>Array.ofSeq in n|>Array.take 32|>Seq.iter(printf "%A "); printfn "\nr[999] has %d digits\nr[9999] has %d digits" ((string n.[999]).Length) ((string n.[9999]).Length)
