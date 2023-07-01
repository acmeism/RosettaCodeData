fun even n =
  n mod 2 = 0;

fun odd n =
  n mod 2 <> 0;

(* bitwise and *)

type werd = Word.word;

fun evenbitw(w: werd) =
  Word.andb(w, 0w2) = 0w0;

fun oddbitw(w: werd) =
  Word.andb(w, 0w2) <> 0w0;
