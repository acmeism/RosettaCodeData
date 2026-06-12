// Base16 numbers represented using only digits greater than 9. Nigel Galloway: June 25th., 2021
let rec fG n g=seq{yield! g; yield! fG n (g|>List.collect(fun g->n|>List.map(fun n->n+g*16)))}
fG [10..15] [10..15]|>Seq.takeWhile((>)5000)|>Seq.iter(fun n->printf "%d(%0x) " n n); printfn ""
