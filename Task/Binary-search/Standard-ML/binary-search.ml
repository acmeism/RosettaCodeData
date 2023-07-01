fun binary_search cmp (key, arr) =
  let
    fun aux slice =
      if ArraySlice.isEmpty slice then
        NONE
      else
        let
 	  val mid = ArraySlice.length slice div 2
        in
	  case cmp (ArraySlice.sub (slice, mid), key)
	  of LESS    => aux (ArraySlice.subslice (slice, mid+1, NONE))
 	   | GREATER => aux (ArraySlice.subslice (slice, 0, SOME mid))
	   | EQUAL   => SOME (#2 (ArraySlice.base slice) + mid)
        end
  in
    aux (ArraySlice.full arr)
  end
