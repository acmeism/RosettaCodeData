structure Test = struct

exception FatalError of string

fun main (prog, args) =
	(let
	  exception Args

	  val switch = ref false

	  fun do_A arg = print ("Argument of -A is " ^ arg ^ "\n")
	  fun do_B ()  = if !switch then print "switch is on\n" else print "switch is off\n"

          fun usage () = print ("Usage: " ^ prog ^ " [-help] [-switch] [-A Argument] [-B]\n")

	  fun parseArgs nil = ()
	    | parseArgs ("-help"     :: ts) = (usage();        parseArgs ts)
	    | parseArgs ("-switch"   :: ts) = (switch := true; parseArgs ts)
	    | parseArgs ("-A" :: arg :: ts) = (do_A arg;       parseArgs ts)
	    | parseArgs ("-B"        :: ts) = (do_B();         parseArgs ts)
	    | parseArgs _ = (usage(); raise Args)

	in
	  parseArgs args handle Args => raise FatalError "Error parsing args. Use the -help option.";
	  (* Do something; *)
	  OS.Process.success
	end)
	handle FatalError e => (print ("Fatal Error:\n"^e^"\n"); OS.Process.failure)
end

(* MLton *)
val _ = Test.main (CommandLine.name(), CommandLine.arguments())
