print ("This program is named " ^ CommandLine.name () ^ ".\n");
val args = CommandLine.arguments ();
Array.appi
  (fn (i, x) => print ("the argument #" ^ Int.toString (i+1) ^ " is " ^ x ^ "\n"))
  (Array.fromList args);
