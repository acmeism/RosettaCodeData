let rec sieve cs x N =
    match cs with
    | [] -> Some(x)
    | (a,n)::rest ->
        let arrProgress = Seq.unfold (fun x -> Some(x, x+N)) x
        let firstXmodNequalA = Seq.tryFind (fun x -> a = x % n)
        match firstXmodNequalA (Seq.take n arrProgress) with
        | None -> None
        | Some(x) -> sieve rest x (N*n)

[ [(2,3);(3,5);(2,7)];
  [(10,11); (4,22); (9,19)];
  [(10,11); (4,12); (12,13)] ]
|> List.iter (fun congruences ->
    let cs =
        congruences
        |> List.map (fun (a,n) -> (a % n, n))
        |> List.sortBy (snd>>(~-))
    let an = List.head cs
    match sieve (List.tail cs) (fst an) (snd an) with
    | None    -> printfn "no solution"
    | Some(x) -> printfn "result = %i" x
)
