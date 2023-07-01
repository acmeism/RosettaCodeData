open System

let gamma z =
    let lanczosCoefficients = [76.18009172947146;-86.50532032941677;24.01409824083091;-1.231739572450155;0.1208650973866179e-2;-0.5395239384953e-5]
    let rec sumCoefficients acc i coefficients =
        match coefficients with
        | []   -> acc
        | h::t -> sumCoefficients (acc + (h/i)) (i+1.0) t
    let gamma = 5.0
    let x = z - 1.0
    Math.Pow(x + gamma + 0.5, x + 0.5) * Math.Exp( -(x + gamma + 0.5) ) * Math.Sqrt( 2.0 * Math.PI ) * sumCoefficients 1.000000000190015 (x + 1.0) lanczosCoefficients

let factorial n = gamma ((float n) + 1.)

let expected n =
    seq {for i in 1 .. n do yield (factorial n) / System.Math.Pow((float n), (float i)) / (factorial (n - i)) }
    |> Seq.sum

let r = System.Random()

let trial n =
    let count = ref 0
    let x = ref 1
    let bits = ref 0
    while (!bits &&& !x) = 0 do
        count := !count + 1
        bits := !bits ||| !x
        x := 1 <<< r.Next(n)
    !count


let tested n times = (float (Seq.sum (seq { for i in 1 .. times do yield (trial n) }))) / (float times)

let results = seq {
    for n in 1 .. 20 do
        let avg = tested n 1000000
        let theory = expected n
        yield n, avg, theory
    }


[<EntryPoint>]
let main argv =
    printfn " N     average   analytical   (error)"
    printfn "------------------------------------"
    results
    |> Seq.iter (fun (n, avg, theory) ->
        printfn "%2i    %2.6f    %2.6f    %+2.3f%%" n avg theory ((avg / theory - 1.) * 100.))
    0
