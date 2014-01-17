fun gray_encode b =
  Word.xorb (b, Word.>> (b, 0w1))

fun gray_decode n =
  let
    fun aux (p, n) =
      if n = 0w0 then p
      else aux (Word.xorb (p, n), Word.>> (n, 0w1))
  in
    aux (n, Word.>> (n, 0w1))
  end;

val s = Word.fmt StringCvt.BIN;
fun aux i =
  if i = 0w32 then
    ()
  else
    let
      val g = gray_encode i
      val b = gray_decode g
    in
      print (Word.toString i ^ " :\t" ^ s i ^ " => " ^ s g ^ " => " ^ s b ^ "\t: " ^ Word.toString b ^ "\n");
      aux (i + 0w1)
    end;
aux 0w0
