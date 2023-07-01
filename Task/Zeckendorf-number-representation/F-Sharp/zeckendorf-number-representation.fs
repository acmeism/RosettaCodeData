let fib = Seq.unfold (fun (x, y) -> Some(x, (y, x + y))) (1,2)

let zeckendorf n =
    if n = 0 then ["0"]
    else
        let folder k state =
            let (n, z) = (fst state), (snd state)
            if n >= k then (n - k, "1" :: z)
            else (n, "0" :: z)
        let fb = fib |> Seq.takeWhile (fun i -> i<=n) |> Seq.toList
        snd (List.foldBack folder fb (n, []))
        |> List.rev

for i in 0 .. 20 do printfn "%2d: %8s" i (String.concat "" (zeckendorf i))
