(*
  A function to filter out continuous subsequences.
  Nigel Galloway July 24th., 2017
*)
let Nonseq n=
  let fn = function
    |((n,0),true )->(n+1,1)
    |((n,_),false)->(n,0)
    |(n,_)        ->n
  {5..(1<<<n)-1}|>Seq.choose(fun i->if fst({0..n-1}|>Seq.takeWhile(fun n->(1<<<(n-1))<i)|>Seq.fold(fun n g->fn (n,(i&&&(1<<<g)>0)))(0,0)) > 1 then Some(i) else None)
