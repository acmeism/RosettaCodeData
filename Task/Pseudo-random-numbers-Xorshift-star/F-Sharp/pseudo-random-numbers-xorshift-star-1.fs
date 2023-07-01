// Xorshift star. Nigel Galloway: August 14th., 2020
let fN=(fun(n:uint64)->n^^^(n>>>12))>>(fun n->n^^^(n<<<25))>>(fun n->n^^^(n>>>27))
let Xstar32=Seq.unfold(fun n->let n=fN n in Some(uint32((n*0x2545F4914F6CDD1DUL)>>>32),n))
let XstarF n=Xstar32 n|>Seq.map(fun n->(float n)/4294967296.0)
