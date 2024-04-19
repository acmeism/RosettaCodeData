// Thue-Morse. Nigel Galloway: April 16th., 2024
let rec fG n g=match n with 0->g |1->g+1 |n ->fG(n/2)(g+n&&&1)
let thueMorse=Seq.initInfinite(fun n->(fG n 0)%2)
thueMorse|>Seq.take 25|>Seq.iter(printf "%d "); printfn ""
