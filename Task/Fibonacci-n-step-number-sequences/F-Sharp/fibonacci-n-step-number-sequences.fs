let fibinit = Seq.append (Seq.singleton 1) (Seq.unfold (fun n -> Some(n, 2*n)) 1)

let fiblike init =
    Seq.append
        (Seq.ofList init)
        (Seq.unfold
            (function   | least :: rest ->
                            let this = least + Seq.reduce (+) rest
                            Some(this, rest @ [this])
                        | _ -> None) init)

let lucas = fiblike [2; 1]

let nacci n = Seq.take n fibinit |> Seq.toList |> fiblike

[<EntryPoint>]
let main argv =
    let start s = Seq.take 15 s |> Seq.toList
    let prefix = "fibo tribo tetra penta hexa hepta octo nona deca".Split()
    Seq.iter
        (fun (p, n) -> printfn "n=%2i, %5snacci -> %A" n p (start (nacci n)))
        (Seq.init prefix.Length (fun i -> (prefix.[i], i+2)))
    printfn "      lucas      -> %A" (start (fiblike [2; 1]))
    0
