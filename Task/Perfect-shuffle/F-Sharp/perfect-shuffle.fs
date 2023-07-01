let perfectShuffle xs =
  let h = (List.length xs) / 2
  xs
  |> List.mapi (fun i x->(if i<h then i * 2 else ((i-h) * 2) + 1), x)
  |> List.sortBy fst
  |> List.map snd

let orderCount n =
  let xs = [1..n]
  let rec spin count ys =
    if xs=ys then count
    else ys |> perfectShuffle |> spin (count + 1)
  xs |> perfectShuffle |> spin 1

[ 8; 24; 52; 100; 1020; 1024; 10000 ] |> List.iter (fun n->n |> orderCount |> printfn "%d %d" n)
