let
  fun loop i =
    if i < 34 then (
      print (Int.fmt StringCvt.BIN i ^ "\t"
           ^ Int.fmt StringCvt.OCT i ^ "\t"
           ^ Int.fmt StringCvt.DEC i ^ "\t"
           ^ Int.fmt StringCvt.HEX i ^ "\n");
      loop (i+1)
    ) else ()
in
  loop 0
end
