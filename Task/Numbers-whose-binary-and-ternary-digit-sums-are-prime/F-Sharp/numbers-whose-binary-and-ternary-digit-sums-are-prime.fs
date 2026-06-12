// binary and ternary digit sums are prime: Nigel Galloway. April 16th., 2021
let fN2,fN3=let rec fG n g=function l when l<n->l+g |l->fG n (g+l%n)(l/n) in (fG 2 0, fG 3 0)
{0..200}|>Seq.filter(fun n->isPrime(fN2 n) && isPrime(fN3 n))|>Seq.iter(printf "%d "); printfn ""
