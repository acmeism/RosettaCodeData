fun curry f x y = f (x, y)
fun uncurry f (x, y) = f x y

fun maxWidths ([], widths) = widths
  | maxWidths (strings, []) = map size strings
  | maxWidths (s :: ss, w :: ws) = Int.max (size s, w) :: maxWidths (ss, ws)

val alignL = uncurry (StringCvt.padRight #" ")
and alignR = uncurry (StringCvt.padLeft #" ")

fun alignC (w, s) =
  alignL (w, alignR ((w + size s) div 2, s))

fun formatTable tab =
  let
    val columnWidths = foldl maxWidths [] tab
  in
    fn f => String.concatWith "\n"
      (map (String.concatWith " " o curry (ListPair.map f) columnWidths) tab)
  end

val readTable =
  map (String.fields (curry op= #"$"))
  o String.tokens (curry op= #"\n")
  o TextIO.inputAll

(* test stdin with all alignments *)
val () = print (String.concatWith "\n\n"
  (map (formatTable (readTable TextIO.stdIn)) [alignL, alignC, alignR]) ^ "\n")
