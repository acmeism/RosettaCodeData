(*
  Nigel Galloway April 7th., 2017.
*)
let SofE =
  let rec fg ng = seq{
    let n = Seq.item 0 ng
    yield n; yield! fg (Seq.cache(Seq.filter (fun g->g%n<>0) (Seq.skip 1 ng)))}
  fg (Seq.initInfinite(id)|>Seq.skip 2)
