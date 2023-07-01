> let a = set ["John"; "Bob"; "Mary"; "Serena"]
  let b = set ["Jim"; "Mary"; "John"; "Bob"];;

val a : Set<string> = set ["Bob"; "John"; "Mary"; "Serena"]
val b : Set<string> = set ["Bob"; "Jim"; "John"; "Mary"]

> (a-b) + (b-a);;
val it : Set<string> = set ["Jim"; "Serena"]
