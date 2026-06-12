// Smallest enclosing circle problem. Nigel Galloway: February 22nd., 2024
let mcc points=
  let fN g=points|>List.map(fun n->(n,d g n))|>List.maxBy snd
  let P1,P2=Seq.allPairs points points|>Seq.maxBy(fun(n,g)->d n g)
  let c1,r1=let ((nx,ny) as n),((gx,gy) as g)=P1,P2 in (((nx+gx)/2.0,(ny+gy)/2.0),(d n g)/2.0)
  match fN c1 with (_,d) when d=r1->(c1,r1)
                  |(P3,_)->let c2,r2=circ P1 P2 P3
                           match fN c2 with (_,d) when d=r2->(c2,r2)
                                           |(P4,_)->[circ P1 P3 P4;circ P2 P3 P4]|>List.minBy snd

let testMCC n=let centre,radius=mcc n in printfn "Minimum Covering Circle is centred at %A with a radius of %f" centre radius
testMCC [(0.0, 0.0);(0.0, 1.0);(1.0, 0.0)]
testMCC [(5.0, -2.0);(-3.0, -2.0);(-2.0, 5.0);(1.0, 6.0);(0.0, 2.0)]
testMCC [(15.85,6.05);(29.82,22.11);(4.84,20.32);(25.47,29.46);(33.65,17.31);(7.30,10.43);(28.15,6.67);(20.85,11.47);(22.83,2.07);(26.28,23.15);(14.39,30.24);(30.24,25.23)]
testMCC [(15.85,6.05);(29.82,22.11);(4.84,20.32);(25.47,29.46);(33.65,17.31);(7.30,10.43);(28.15,6.67);(20.85,11.47);(22.83,2.08);(26.28,23.15);(14.39,30.24);(30.24,25.23)]
