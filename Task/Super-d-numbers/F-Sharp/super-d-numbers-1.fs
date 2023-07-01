// Generate Super-N numbers. Nigel Galloway: October 12th., 2019
let superD N=
  let      I=bigint(pown 10 N)
  let      G=bigint N
  let      E=G*(111111111I%I)
  let rec fL n=match (E-n%I).IsZero with true->true |_->if (E*10I)<n then false else fL (n/10I)
  seq{1I..999999999999999999I}|>Seq.choose(fun n->if fL (G*n**N) then Some n else None)
