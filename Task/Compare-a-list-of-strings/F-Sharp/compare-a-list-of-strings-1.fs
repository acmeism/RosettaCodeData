let allEqual strings = Seq.isEmpty strings || Seq.forall (fun x -> x = Seq.head strings) (Seq.tail strings)
let ascending strings = Seq.isEmpty strings || Seq.forall2 (fun x y -> x < y) strings (Seq.tail strings)
