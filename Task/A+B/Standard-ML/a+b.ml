(*
 * val split : string -> string list
 * splits a string at it spaces
 *)
val split = String.fields (fn #" " => true | _ => false)

(*
 * val removeNl : string -> string
 * removes the occurence of "\n" in a string
 *)
val removeNl = String.translate (fn #"\n" => "" | c => implode [c])

(*
 * val aplusb : unit -> int
 * reads a line and gets the sum of the numbers
 *)
fun aplusb () =
	let
	  val input  = removeNl (valOf (TextIO.inputLine TextIO.stdIn))
	in
	  foldl op+ 0 (map (fn s => valOf (Int.fromString s)) (split input))
	end
