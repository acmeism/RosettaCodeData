randLS 4 |> Seq.take 10000 |> Seq.map asNormLS |> Seq.countBy id |> Seq.iter(fun n->printf "%A was produced %d times\n\n" (fst n)(snd n))
