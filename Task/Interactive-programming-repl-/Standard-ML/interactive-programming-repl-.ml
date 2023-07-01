$ sml
Standard ML of New Jersey v110.67 [built: Fri Jul  4 09:00:58 2008]
- fun f (s1, s2, sep) = String.concatWith sep [s1, "", s2];
[autoloading]
[library $SMLNJ-BASIS/basis.cm is stable]
[autoloading done]
val f = fn : string * string * string -> string
- f ("Rosetta", "Code", ":");
val it = "Rosetta::Code" : string
-
