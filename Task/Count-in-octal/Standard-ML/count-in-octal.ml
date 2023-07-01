local
  fun count n = (print (Int.fmt StringCvt.OCT n ^ "\n"); count (n+1))
in
  val _ = count 0
end
