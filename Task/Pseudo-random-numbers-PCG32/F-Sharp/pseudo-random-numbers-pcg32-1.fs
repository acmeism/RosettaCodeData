// PCG32. Nigel Galloway: August 13th., 2020
let N=6364136223846793005UL
let seed n g=let g=g<<<1|||1UL in (g,(g+n)*N+g)
let pcg32=Seq.unfold(fun(n,g)->let rot,xs=uint32(g>>>59),uint32(((g>>>18)^^^g)>>>27) in Some(uint32((xs>>>(int rot))|||(xs<<<(-(int rot)&&&31))),(n,g*N+n)))
let pcgFloat n=pcg32 n|>Seq.map(fun n-> (float n)/4294967296.0)
