let g=[|0..10|]
lC 10 |> Seq.map(fun n->lc2p n g) |>  Seq.length
