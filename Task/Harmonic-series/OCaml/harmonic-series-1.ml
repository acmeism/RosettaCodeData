let series =
  Seq.scan (fun sum i -> Q.(sum + inv ~$i)) Q.one (Seq.ints 2)

let positions =
  Seq.unfold
    (fun (n, s) ->
      Seq.uncons (Seq.drop_while (fun iq -> Q.(n >= snd iq)) s)
      |> Option.map (fun (iq, s) -> fst iq, Q.(n + one, s)))
    (Q.one, Seq.zip (Seq.ints 1) series)
