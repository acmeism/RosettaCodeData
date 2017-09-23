(*
  An interesting implementation of The Sieve of Eratosthenes.
  Nigel Galloway April 7th., 2017.
*)
let SofE =
  let rec fn n g = seq{ match n with
                        |1 -> yield false; yield! fn g g
                        |_ -> yield  true; yield! fn (n-1) g}
  let rec fg ng = seq{
    let g = (Seq.findIndex(id) ng)+2
    yield g; yield! fg (Seq.cache(Seq.map2(&&) ng (fn (g-1) g)))}
  fg (Seq.initInfinite(fun x->true))
