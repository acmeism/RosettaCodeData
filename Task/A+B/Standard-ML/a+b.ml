(*
 * val split : string -> string list
 * splits a string at it spaces
 *)
val split = String.tokens Char.isSpace

(*
 * val sum : int list -> int
 * computes the sum of a list of numbers
 *)
val sum = foldl op+ 0

(*
 * val aplusb : unit -> int
 * reads a line and gets the sum of the numbers
 *)
fun aplusb () =
  let
    val input = valOf (TextIO.inputLine TextIO.stdIn)
  in
    (sum o List.mapPartial Int.fromString o split) input
  end
