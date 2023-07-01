let factorsOf (num) =
    Seq.unfold (fun (f, n) ->
        let rec genFactor (f, n) =
            if f > n then None
            elif n % f = 0 then Some (f, (f, n/f))
            else genFactor (f+1, n)
        genFactor (f, n)) (2, num)

let showLines = Seq.concat (seq { yield seq{ yield(Seq.singleton 1)}; yield (Seq.skip 2 (Seq.initInfinite factorsOf))})

showLines |> Seq.iteri (fun i f -> printfn "%d = %s" (i+1) (String.Join(" * ", Seq.toArray f)))
