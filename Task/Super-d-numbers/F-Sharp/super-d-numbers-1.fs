// Generate Super-N numbers. Nigel Galloway: October 12th., 2019
let rec fL (E:bigint) I=function n when E>n->false |n when (E-n%I).IsZero->true |n->fL E I (n/10I)
let superD N=
  let I,G=bigint(pown 10 N),bigint N
  let fL=fL (G*(111111111I%I)) I in Seq.initInfinite((+)1>>bigint)|>Seq.filter(fun n->fL (G*n**N))
