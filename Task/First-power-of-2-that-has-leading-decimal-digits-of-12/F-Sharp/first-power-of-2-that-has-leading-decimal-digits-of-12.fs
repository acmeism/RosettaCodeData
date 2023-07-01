// First power of 2 that has specified leading decimal digits. Nigel Galloway: March 14th., 2021
let fG n g=let fN l=let l=10.0**(l-floor l) in l>=n && l<g in let f=log10 2.0 in seq{1..0x0FFFFFFF}|>Seq.filter(float>>(*)f>>fN)
printfn "p(23,1)->%d"       (int(Seq.item      0 (fG 2.3 2.4)))
printfn "p(99,1)->%d"       (int(Seq.item      0 (fG 9.9 10.0)))
printfn "p(12,1)->%d"       (int(Seq.item      0 (fG 1.2 1.3)))
printfn "p(12,2)->%d"       (int(Seq.item      1 (fG 1.2 1.3)))
printfn "p(123,45)->%d"     (int(Seq.item     44 (fG 1.23 1.24)))
printfn "p(123,12345)->%d"  (int(Seq.item  12344 (fG 1.23 1.24)))
printfn "p(123,678910)->%d" (int(Seq.item 678909 (fG 1.23 1.24)))
