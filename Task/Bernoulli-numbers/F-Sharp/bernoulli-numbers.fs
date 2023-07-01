open MathNet.Numerics
open System
open System.Collections.Generic

let calculateBernoulli n =
    let ℚ(x) = BigRational.FromInt x
    let A = Array.init<BigRational> (n+1) (fun x -> ℚ(x+1))

    for m in [1..n] do
        A.[m] <- ℚ(1) / (ℚ(m) + ℚ(1))
        for j in [m..(-1)..1] do
            A.[j-1] <- ℚ(j) * (A.[j-1] - A.[j])
    A.[0]

[<EntryPoint>]
let main argv =
    for n in [0..60] do
        let bernoulliNumber = calculateBernoulli n
        match bernoulliNumber.Numerator.IsZero with
        | false ->
            let formatedString = String.Format("B({0, 2}) = {1, 44} / {2}", n, bernoulliNumber.Numerator, bernoulliNumber.Denominator)
            printfn "%s" formatedString
        | true ->
            printf ""
    0
