let (!) f s = Seq.isEmpty s || Seq.forall2 f s (Seq.tail s)
