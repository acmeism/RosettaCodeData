(*
  A function to generate only the non-continuous subsequences.
  Nigel Galloway July 20th., 2017
*)
let N n =
  let     fn n = Seq.map (fun g->(2<<<n)+g)
  let rec fg n = seq{if n>0 then yield! seq{1..((1<<<n)-1)}|>fn n; yield! fg (n-1)|>fn n}
  Seq.collect fg ({1..(n-2)})
