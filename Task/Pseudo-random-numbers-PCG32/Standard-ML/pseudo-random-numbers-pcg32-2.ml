fun test1 (rand, state) =
  (print (Word32.fmt StringCvt.DEC rand ^ "\n"); state)

local
  val prependFormatted =
    fn (i, v, lst) => Int.toString i ^ ": " ^ Int.toString v :: lst
  and counts = IntArray.array (5, 0)
in
  fun test2 (rand, state) =
    let
      val i = LargeWord.toInt (LargeWord.>> (0w5 * Word32.toLarge rand, 0w32))
    in
      IntArray.update (counts, i, IntArray.sub (counts, i) + 1); state
    end
  fun test2res () =
    IntArray.foldri prependFormatted [] counts
end

fun doTimes (_, 0, state) = state
  | doTimes (f, n, state) = doTimes (f, n - 1, f state)

val _ = doTimes (test1 o pcg32Random, 5, pcg32Init (42, 54))

val _ = doTimes (test2 o pcg32Random, 100000, pcg32Init (987654321, 1))
val () = print ("\n" ^ ((String.concatWith ", " o test2res) ()) ^ "\n")
