Seq.unfold(fun (f1, f2) -> Some(f1, (f2, f2+f1))) ("1", "0")
