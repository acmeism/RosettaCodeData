(*

  The Rosetta Code integer square root task, in Standard ML.

  Compile with, for example:

     mlton isqrt.sml

*)

val zero = IntInf.fromInt (0)
val one = IntInf.fromInt (1)
val seven = IntInf.fromInt (7)
val word1 = Word.fromInt (1)
val word2 = Word.fromInt (2)

fun
find_a_power_of_4_greater_than_x (x) =
let
  fun
  loop (q) =
  if x < q then
    q
  else
    loop (IntInf.<< (q, word2))
in
  loop (one)
end;

fun
isqrt (x) =
let
  fun
  loop (q, z, r) =
  if q = one then
    r
  else
    let
      val q = IntInf.~>> (q, word2)
      val t = z - r - q
      val r = IntInf.~>> (r, word1)
    in
      if t < zero then
        loop (q, z, r)
      else
        loop (q, t, r + q)
    end
in
  loop (find_a_power_of_4_greater_than_x (x), x, zero)
end;

fun
insert_separators (s, sep) =
(* Insert separator characters (such as #",", #".", #" ") in a numeral
   that is already in string form. *)
let
  fun
  loop (revchars, i, newchars) =
  case (revchars, i) of
      ([], _) => newchars
    | (revchars, 3) => loop (revchars, 0, sep :: newchars)
    | (c :: tail, i) => loop (tail, i + 1, c :: newchars)
in
  implode (loop (rev (explode s), 0, []))
end;

fun
commas (s) =
(* Insert commas in a numeral that is already in string form. *)
insert_separators (s, #",");

val pad_with_spaces = StringCvt.padLeft #" "

fun
main () =
let
  val i = ref 0
in
  print ("isqrt(i) for 0 <= i <= 65:\n\n");

  i := 0;
  while !i < 65 do (
    print (IntInf.toString (isqrt (IntInf.fromInt (!i))));
    print (" ");
    i := !i + 1
  );
  print (IntInf.toString (isqrt (IntInf.fromInt (65))));
  print ("\n\n\n");

  print ("isqrt(7**i) for 1 <= i <= 73, i odd:\n\n");
  print (pad_with_spaces 2 "i");
  print (pad_with_spaces 85 "7**i");
  print (pad_with_spaces 44 "sqrt(7**i)");
  print ("\n");

  i := 1;
  while !i <= 131 do (
    print ("-");
    i := !i + 1
  );
  print ("\n");

  i := 1;
  while !i <= 73 do (
    let
      val pow7 = IntInf.pow (seven, !i)
      val root = isqrt (pow7)
    in
      print (pad_with_spaces 2 (Int.toString (!i)));
      print (pad_with_spaces 85 (commas (IntInf.toString pow7)));
      print (pad_with_spaces 44 (commas (IntInf.toString root)));
      print ("\n");
      i := !i + 2
    end
  )
end;

main ();

(* local variables: *)
(* mode: sml *)
(* sml-indent-level: 2 *)
(* sml-indent-args: 2 *)
(* end: *)
