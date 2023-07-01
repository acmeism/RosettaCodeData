open System.Numerics
open System

let rec gamma (z: Complex) =
    let mutable z = z
    let lanczosCoefficients = [| 676.520368121885; -1259.1392167224; 771.323428777653; -176.615029162141; 12.5073432786869; -0.13857109526572; 9.98436957801957E-06; 1.50563273514931E-07 |]

    if z.Real < 0.5 then
        Math.PI / (sin (Math.PI * z) * gamma (1.0 - z))
    else
        let mutable x = Complex.One
        z <- z - 1.0

        for i = 0 to lanczosCoefficients.Length - 1 do
            x <- x + lanczosCoefficients.[i] / (z + Complex(i, 0) + 1.0)

        let t = z + float lanczosCoefficients.Length - 0.5
        sqrt (2.0 * Math.PI) * (t ** (z + 0.5)) * exp (-t) * x

Seq.iter (fun i -> printfn "Gamma(%f) = %A" i (gamma (Complex(i, 0)))) [ 0 .. 100 ]
Seq.iter2 (fun i j -> printfn "Gamma(%f + i%f) = %A" i j (gamma (Complex(i, j)))) [ 0 .. 100 ] [ 0 .. 100 ]
