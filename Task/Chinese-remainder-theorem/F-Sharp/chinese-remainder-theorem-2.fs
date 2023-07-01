//Chinese Division Theorem: Nigel Galloway: April 3rd., 2017
let CD n g =
  match Seq.fold(fun n g->if (gcd n g)=1 then n*g else 0) 1 g with
  |0 -> None
  |fN-> Some ((Seq.fold2(fun n i g -> n+i*(fN/g)*(MI g ((fN/g)%g))) 0 n g)%fN)
