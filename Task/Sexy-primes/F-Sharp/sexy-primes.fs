// Sexy primes. Nigel Galloway: October 2nd., 2018
let n=pCache |> Seq.takeWhile(fun n->n<1000035) |> Seq.filter(fun n->(not (isPrime(n+6)) && (not isPrime(n-6))))) |> Array.ofSeq
printfn "There are %d unsexy primes less than 1,000,035. The last 10 are:" n.Length
Array.skip (n.Length-10) n |> Array.iter(fun n->printf "%d " n); printfn ""
let ni=pCache |> Seq.takeWhile(fun n->n<1000035) |> Seq.filter(fun n->isPrime(n-6)) |> Array.ofSeq
printfn "There are %d sexy prime pairs all components of which are less than 1,000,035. The last 5 are:" ni.Length
Array.skip (ni.Length-5) ni |> Array.iter(fun n->printf "(%d,%d) " (n-6) n); printfn ""
let nig=ni |> Array.filter(fun n->isPrime(n-12))
printfn "There are %d sexy prime triplets all components of which are less than 1,000,035. The last 5 are:" nig.Length
Array.skip (nig.Length-5) nig |> Array.iter(fun n->printf "(%d,%d,%d) " (n-12) (n-6) n); printfn ""
let nige=nig |> Array.filter(fun n->isPrime(n-18))
printfn "There are %d sexy prime quadruplets all components of which are less than 1,000,035. The last 5 are:" nige.Length
Array.skip (nige.Length-5) nige |> Array.iter(fun n->printf "(%d,%d,%d,%d) " (n-18) (n-12) (n-6) n); printfn ""
let nigel=nige |> Array.filter(fun n->isPrime(n-24))
printfn "There are %d sexy prime quintuplets all components of which are less than 1,000,035. The last 5 are:" nigel.Length
Array.skip (nigel.Length-5) nigel |> Array.iter(fun n->printf "(%d,%d,%d,%d,%d) " (n-24) (n-18) (n-12) (n-6) n); printfn ""
