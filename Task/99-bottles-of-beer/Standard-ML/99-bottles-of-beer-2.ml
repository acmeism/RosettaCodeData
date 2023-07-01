fun capitalize s =
  (str o Char.toUpper o String.sub) (s, 0) ^ String.extract (s, 1, NONE)

fun unfoldN (0, _, _) = []
  | unfoldN (n, f, init) =
      (fn (item, next) => item :: unfoldN (n - 1, f, next)) (f init)

fun textBlocks 0 = ("no more bottles", "Go to the store and buy some more", 99)
  | textBlocks i = (if i = 1 then "1 bottle" else Int.toString i ^ " bottles",
      "Take one down and pass it around", i - 1)

fun clauses i =
  let
    val (f, s, n) = textBlocks i
    val f2 = f ^ " of beer"
  in
    (f2 ^ " on the wall", f2, s, n)
  end

fun makeLine l =
  concat (ListPair.map op^ (l, [", ", ".\n"]))

fun verse (f1, f2, s, n) =
  let
    val next as (f1', f2', _, _) = clauses n
  in
    (makeLine [capitalize f1, f2] ^ makeLine [s, f1'], next)
  end

val () = (print o String.concatWith "\n" o unfoldN) (100, verse, clauses 99)
