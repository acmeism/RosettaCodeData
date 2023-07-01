open System
open PrimeDecomp // Has the decompose function from the Prime decomposition task

let data = [112272537195293L; 112582718962171L; 112272537095293L; 115280098190773L; 115797840077099L; 1099726829285419L]
let decomp num = decompose num 2L

let largestMinPrimeFactor (numbers: int64 list) =
    let decompDetails = Async.Parallel [ for n in numbers -> async { return n, decomp n } ] // Compute the number and its prime decomposition list
                        |> Async.RunSynchronously                                           // Start and wait for all parallel computations to complete.
                        |> Array.sortBy (snd >> List.min >> (~-))                           // Sort in descending order, based on the min prime decomp number.

    decompDetails.[0]

let showLargestMinPrimeFactor numbers =
    let number, primeList = largestMinPrimeFactor numbers
    printf "Number %d has largest minimal factor:\n    " number
    List.iter (printf "%d ") primeList

showLargestMinPrimeFactor data
