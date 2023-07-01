let choose m n =
    let rec fC prefix m from = seq {
        let rec loopFor f = seq {
            match f with
            | [] -> ()
            | x::xs ->
                yield (x, fC [] (m-1) xs)
                yield! loopFor xs
        }
        if m = 0 then yield prefix
        else
            for (i, s) in loopFor from do
                for x in s do
                    yield prefix@[i]@x
    }
    fC [] m [0..(n-1)]

[<EntryPoint>]
let main argv =
    choose 3 5
    |> Seq.iter (printfn "%A")
    0
