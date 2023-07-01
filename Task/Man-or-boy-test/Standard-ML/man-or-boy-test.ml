fun a (k, x1, x2, x3, x4, x5) =
  if k <= 0 then
    x4 () + x5 ()
  else let
    val m = ref k
    fun b () = (
      m := !m - 1;
      a (!m, b, x1, x2, x3, x4)
    )
  in
    b ()
  end

val () =
  print (Int.toString (a (10, fn () => 1, fn () => ~1, fn () => ~1, fn () => 1, fn () => 0)) ^ "\n")
