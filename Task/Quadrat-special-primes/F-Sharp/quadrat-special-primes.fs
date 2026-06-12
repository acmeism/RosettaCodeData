//Quadrat special primes. Nigel Galloway: January 16th., 2023
let isPs(n:int)=MathNet.Numerics.Euclid.IsPerfectSquare n
let rec fG n g=seq{match Seq.tryHead g with Some h when isPs(h-n)->yield h; yield! fG h g |Some _->yield! fG n g |_->()}
fG 2 (primes32()|>Seq.takeWhile((>)16000))|>Seq.iter(printf "%d "); printfn ""
