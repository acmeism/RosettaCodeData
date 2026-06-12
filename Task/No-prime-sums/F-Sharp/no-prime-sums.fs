// Generate No prime sums. Nigel Galloway: April 18th., 2025
let fG n (g:uint64)=n|>List.forall((+)g>>Open.Numeric.Primes.Number.IsPrime>>not)
let noPS()=let rec noPS n g=seq{match fG n g with false->yield! noPS n (g+1uL) |_->yield g; yield! noPS (n@(n|>List.map((+)g))) (g+1uL)} in noPS [0uL] 1uL
let noPSodd()=let rec noPS n g=seq{match fG n g with false->yield! noPS n (g+2uL) |_->yield g; yield! noPS (n@(n|>List.map((+)g))) (g+2uL)} in noPS [0uL] 1uL
let noPSeven()=let rec noPS n g=seq{match fG n g with false->yield! noPS n (g+2uL) |_->yield g; yield! noPS (n@(n|>List.map((+)g))) (if g=1uL then 2uL else g+2uL)} in noPS [0uL] 1uL
noPS()|>Seq.take 10|>Seq.iter(printfn "%d ")
noPSodd()|>Seq.take 10|>Seq.iter(printfn "%d ");;
noPSeven()|>Seq.take 10|>Seq.iter(printfn "%d ");;
