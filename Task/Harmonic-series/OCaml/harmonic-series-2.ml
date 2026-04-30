let _ =
  let print fmt = Format.printf (fmt ^^ "\n") in
  Seq.iteri (fun i h -> print "H(%d) =\t%a" (i + 1) Q.pp_print h) (Seq.take 20 series);
  Seq.iteri (fun i n -> print "nth harmonic > %d:\t%d" (i + 1) n) (Seq.take 10 positions)
