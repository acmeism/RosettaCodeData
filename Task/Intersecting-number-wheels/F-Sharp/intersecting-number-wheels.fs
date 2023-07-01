// Wheels within wheels. Nigel Galloway: September 30th., 2019.
let N(n)=fun()->n
let wheel(n:(unit->int)[])=let mutable g= -1 in (fun()->g<-(g+1)%n.Length; n.[g]())
let A1=wheel[|N(1);N(2);N(3)|]
for n in 0..20 do printf "%d " (A1())
printfn ""
let B2=wheel[|N(3);N(4)|]
let A2=wheel[|N(1);B2;N(2)|]
for n in 0..20 do printf "%d " (A2())
printfn ""
let D3=wheel[|N(6);N(7);N(8)|]
let A3=wheel[|N(1);D3;D3|]
for n in 0..20 do printf "%d " (A3())
printfn ""
let B4=wheel[|N(3);N(4)|]
let C4=wheel[|N(5);B4|]
let A4=wheel[|N(1);B4;C4|]
for n in 0..20 do printf "%d " (A4())
printfn ""
