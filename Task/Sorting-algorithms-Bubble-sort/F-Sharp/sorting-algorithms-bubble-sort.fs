let BubbleSort (lst : list<int>) =
    let rec sort accum rev lst =
        match lst, rev with
        | [], true -> accum |> List.rev
        | [], false -> accum |> List.rev |> sort [] true
        | x::y::tail, _ when x > y -> sort (y::accum) false (x::tail)
        | head::tail, _ -> sort (head::accum) rev tail
    sort [] true lst
