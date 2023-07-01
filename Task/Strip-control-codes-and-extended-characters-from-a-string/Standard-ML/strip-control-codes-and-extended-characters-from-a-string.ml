(* string -> string *)
val stripCntrl = concat o String.tokens Char.isCntrl

(* string -> string *)
val stripCntrlAndExt = concat o String.tokens (not o Char.isPrint)
