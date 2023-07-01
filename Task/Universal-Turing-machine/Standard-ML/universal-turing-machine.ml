(*** Signatures ***)

signature TAPE = sig
	datatype move = Left | Right | Stay

	type ''a tape
	val empty : ''a tape
	val moveLeft  : ''a tape -> ''a tape
	val moveRight : ''a tape -> ''a tape
	val move      : ''a tape -> move -> ''a tape
	val getSymbol : ''a tape -> ''a option
	val write     : ''a option -> ''a tape -> ''a tape
	val leftOf    : ''a tape -> ''a option list	(* Symbols left of the head in reverse order *)
	val rightOf   : ''a tape -> ''a option list	(* Symbols right of of the head *)
end

signature MACHINE = sig
	structure Tape : TAPE

	type state = int

	(* ''a is band alphabet type *)
	type ''a transitions = (state * ''a option Vector.vector) ->
	                       (state * (Tape.move * ''a option) Vector.vector)

	type ''a configuration = { state : state, tapes : ''a Tape.tape Vector.vector }

	type ''a machine = {
			alphabet : ''a Vector.vector,		(* (not used) *)
			states : state Vector.vector,		(* (not used) *)
			start  : state,				(* element of stats *)
			final  : state,				(* element of stats *)
			transitions : ''a transitions,		(* transitions *)
			tapes  : ''a Tape.tape Vector.vector	(* vector of the initial tapes *)
		}
end



signature UNIVERSALMACHINE = sig
	structure Machine : MACHINE

	val start : ''a Machine.machine -> ''a Machine.configuration

	(* Find a holding configuration (limited by n steps)
	 * Execute the handler for each step *)
	val simulate : (''a Machine.configuration -> unit) -> ''a Machine.machine -> int option -> ''a Machine.configuration option
end


(*** Implementation ***)

structure Tape :> TAPE = struct
	
	(*
	 * NONE   => blank field
	 * SOME a => written field
	 *)
	type ''a symbol = ''a option

	datatype move = Left | Right | Stay

	(*
	 * Four cases:
	 * 1   The tape is complete empty.
	 * 2   The head is in the written area.
	 *     On the right and on the left handside are symbols,
	 *     On the head is a symbol.
	 * 3/4 The head is (n-1) fields over the right/left edge of the written area.
	 *     There is at least one entry and a rest list of entries.
	 *)
	datatype ''a tape =
	  Empty
	| Middle  of ''a symbol list * ''a symbol * ''a symbol list
	| LeftOf  of ''a symbol * ''a symbol list * int
	| RightOf of ''a symbol * ''a symbol list * int

	val empty = Empty

	fun rep a 0 = nil
	  | rep a n = a :: rep a (n-1)

	fun leftOf  (Empty)              = nil
	  | leftOf  (Middle (ls, _, _))  = ls
	  | leftOf  (RightOf (r, rs, i)) = rep NONE i @ r :: rs
	  | leftOf  (LeftOf _)           = nil

	fun rightOf (Empty)              = nil
	  | rightOf (Middle (_, _, rs))  = rs
	  | rightOf (RightOf _)          = nil
	  | rightOf (LeftOf (l, ls, i))  = rep NONE i @ l :: ls
	
	fun write (NONE) t = t (* Cannot write a blank field! *)
	  | write a      t = Middle (leftOf t, a, rightOf t)

	fun getSymbol (Middle (_, m, _)) = m
	  | getSymbol _ = NONE (* blank *)


	fun moveRight (Empty) = Empty
	  | moveRight (Middle (ls, m,   nil)) = RightOf (m, ls, 0)
	  | moveRight (Middle (ls, m, r::rs)) = Middle (m::ls, r, rs)
	  | moveRight (RightOf (l, ls, n))    = RightOf (l, ls, n+1)
	  | moveRight (LeftOf (r, rs, 0))     = Middle (nil, r, rs)
	  | moveRight (LeftOf (r, rs,  n))    = LeftOf (r, rs, n-1)


	fun moveLeft (Empty) = Empty
	  | moveLeft (Middle (nil, m,   rs)) = LeftOf (m, rs, 0)
	  | moveLeft (Middle (l::ls, m, rs)) = Middle (ls, l, m::rs)
	  | moveLeft (RightOf (l, ls, 0))    = Middle (ls, l, nil)
	  | moveLeft (RightOf (l, ls, n))    = RightOf (l, ls, n-1)
	  | moveLeft (LeftOf (r, rs,  n))    = LeftOf (r, rs, n+1)


	fun move tape Stay  = tape
	  | move tape Right = moveRight tape
	  | move tape Left  = moveLeft  tape

	(* Test *)
	local
		val tape : int tape = empty		(* [] *)
		val tape = moveRight tape		(* [] *)
		val NONE = getSymbol tape
		val tape = write (SOME 42) tape		(* [42] *)
		val (SOME 42) = getSymbol tape
		val tape = moveRight tape		(* 42, [] *)
		val tape = moveRight tape		(* 42, , [] *)
		val NONE = getSymbol tape
		val tape = moveLeft tape		(* 42, [] *)
		val NONE = getSymbol tape
		val tape = moveLeft tape		(* [42] *)
		val (SOME 42) = getSymbol tape
		val tape = write NONE tape		(* [42] *) (* !!! *)
		val (SOME 42) = getSymbol tape
		val tape = moveLeft tape		(* [], 42 *)
		val tape = moveLeft tape		(* [], , 42 *)
		val tape = write (SOME 47) tape		(* [47], , 42 *)
		val (SOME 47) = getSymbol tape
		val tape = moveRight tape		(* 47, [], 42 *)
		val NONE = getSymbol tape
		val tape = moveRight tape		(* 47, , [42] *)
		val (SOME 42) = getSymbol tape
	in end
end

structure Machine :> MACHINE = struct
	structure Tape = Tape

	type state = int

	(* ''a is band alphabet type *)
	type ''a transitions = (state * ''a option Vector.vector) ->
	                       (state * (Tape.move * ''a option) Vector.vector)

	type ''a configuration = { state : state, tapes : ''a Tape.tape Vector.vector }

	type ''a machine = {
			alphabet : ''a Vector.vector,
			states : state Vector.vector,
			start  : state,
			final  : state,
			transitions : ''a transitions,
			tapes  : ''a Tape.tape Vector.vector
		}
end

structure UniversalMachine :> UNIVERSALMACHINE = struct
	
	structure Machine = Machine
	
	fun start ({ start, tapes, ... } : ''a Machine.machine) : ''a Machine.configuration = {
			state = start,
			tapes = tapes
		}
	
	fun doTransition ({ state, tapes } : ''a Machine.configuration)
	    ((state', actions) : (Machine.state * (Machine.Tape.move * ''a option) Vector.vector))
		: ''a Machine.configuration = {
			state = state',
			tapes = Vector.mapi (fn (i, tape) =>
					let val (move, write) = Vector.sub (actions, i)
					    val tape'  = Machine.Tape.write write tape
					    val tape'' = Machine.Tape.move tape' move
					in tape'' end) tapes
		}

	fun getSymbols ({ tapes, ... } : ''a Machine.configuration) : ''a option Vector.vector =
		Vector.map (Machine.Tape.getSymbol) tapes
	
	fun step ({ transitions, ... } : ''a Machine.machine) (conf : ''a Machine.configuration) : ''a Machine.configuration =
		doTransition conf (transitions (#state conf, getSymbols conf))
		
	fun isFinal ({final, ...} : ''a Machine.machine) ({state, ...} : ''a Machine.configuration) : bool =
		final = state
	
	fun iter term (SOME 0) f s = NONE
	  | iter term (SOME n) f s = if term s then SOME s else iter term (SOME (n-1)) f (f s)
	  | iter term NONE     f s = if term s then SOME s else iter term NONE f (f s)


	fun simulate handler (machine : ''a Machine.machine) optcount =
		let val endconf = iter (isFinal machine) optcount (fn conf => (handler conf; step machine conf)) (start machine)
		in case endconf of NONE => NONE | SOME conf => (handler conf; endconf) end
		
end


structure ExampleMachines = struct
	
	structure Machine = UniversalMachine.Machine

	(* Tranform the 5-Tuple notation into the vector function *)
	fun makeTransitions nil : ''a Machine.transitions = (fn (t, vec) => (print (Int.toString t); raise Subscript))
	  | makeTransitions ((s : Machine.state,
	  		      read : ''a option,
	                      write : ''a option,
			      move : Machine.Tape.move,
			      s' : Machine.state) :: ts) =
	  	fn (t, vec) =>
	  		if s=t andalso vec=(Vector.fromList [read])
		        then (s', Vector.fromList [(move, write)])
			else makeTransitions ts (t, vec)

	(* `createTape xs` creates an tape initialized by xs, where the head stands on the first element of xs *)
	fun createTape' nil     = Machine.Tape.empty
	  | createTape' (x::xs) = Machine.Tape.moveLeft (Machine.Tape.write x (createTape' xs))
	
	fun createTape xs = Machine.Tape.moveRight (createTape' (rev xs))

	
	(* Convert a tape into a string to print it. It needs a function that converts each symbol to string *)
	fun tapeToStr (symStr : ''a -> string) (tape : ''a Machine.Tape.tape) : string =
		let val left     : ''a option list = rev (Machine.Tape.leftOf tape)
		    val right    : ''a option list = Machine.Tape.rightOf tape
		    val current  : ''a option      = Machine.Tape.getSymbol tape
		    val symToStr : ''a option -> string = (fn (NONE) => "#" | (SOME a) => symStr a)
		in
		    String.concatWith " " ((map symToStr left) @ [ "|" ^ symToStr current ^ "|" ] @ (map symToStr right))
		end
	
	(* Convert a vector to a list *)
	fun vectToList vect = List.tabulate (Vector.length vect, fn i => Vector.sub (vect, i))


	(* Do this before every step and after the last step. *)
	fun handler (symToStr : ''a -> string) ({state, tapes} : ''a Machine.configuration) : unit =
		let
			val str = "State " ^ Int.toString state ^ "\n" ^
			String.concat (vectToList (Vector.mapi (fn (i, tape) => "Tape #" ^ Int.toString i ^ ": " ^
			tapeToStr symToStr tape ^ "\n") tapes))
		in
			print str
		end


	(* Simulate and make result into string *)
	fun simulate (symToStr : ''a -> string) (machine : ''a Machine.machine)
	    (optcount : int option) : string =
		case (UniversalMachine.simulate (handler symToStr) machine optcount) of
		  NONE => "Did not terminate."
		| SOME ({state, tapes} : ''a Machine.configuration) => "Terminated."

	

	(* Now finaly the machines! *)

	val incrementer : unit Machine.machine = {
		alphabet = Vector.fromList [()],
		states   = Vector.fromList [0, 1],
		start    = 0,
		final    = 1,
		tapes    = Vector.fromList [createTape (map SOME [(), (), (), ()])],
		transitions = makeTransitions [
			(0, SOME (), SOME (), Machine.Tape.Right, 0),
			(0, NONE,    SOME (), Machine.Tape.Stay,  1)]
	}

	val busybeaver : unit Machine.machine = {
		alphabet = Vector.fromList [()],
		states   = Vector.fromList [0, 1, 2, 3],
		start    = 0,
		final    = 3,
		tapes    = Vector.fromList [Machine.Tape.empty],
		transitions = makeTransitions [
			(0, NONE,    SOME (), Machine.Tape.Right, 1),
			(0, SOME (), SOME (), Machine.Tape.Left,  2),
			(1, NONE,    SOME (), Machine.Tape.Left,  0),
			(1, SOME (), SOME (), Machine.Tape.Right, 1),
			(2, NONE,    SOME (), Machine.Tape.Left,  1),
			(2, SOME (), SOME (), Machine.Tape.Stay,  3)]
	}

	val sorting : int Machine.machine = {
		alphabet = Vector.fromList [1,2,3],
		states   = Vector.fromList [0,1,2,3,4,5],
		start    = 1,
		final    = 0,
		tapes    = Vector.fromList [createTape (map SOME [2, 1, 2, 2, 1, 1])],
		transitions = makeTransitions [
			(1, SOME 1, SOME 1, Machine.Tape.Right, 1),
			(1, SOME 2, SOME 3, Machine.Tape.Right, 2),
			(1, NONE,   NONE,   Machine.Tape.Left,  5),
			(2, SOME 1, SOME 1, Machine.Tape.Right, 2),
			(2, SOME 2, SOME 2, Machine.Tape.Right, 2),
			(2, NONE,   NONE,   Machine.Tape.Left,  3),
			(3, SOME 1, SOME 2, Machine.Tape.Left,  3),
			(3, SOME 2, SOME 2, Machine.Tape.Left,  3),
			(3, SOME 3, SOME 2, Machine.Tape.Left,  5),
			(4, SOME 1, SOME 1, Machine.Tape.Left,  4),
			(4, SOME 2, SOME 2, Machine.Tape.Left,  4),
			(4, SOME 3, SOME 1, Machine.Tape.Right, 1),
			(5, SOME 1, SOME 1, Machine.Tape.Left,  5),
			(5, NONE,   NONE,   Machine.Tape.Right, 0)]
		}
end

(** Invoke Simulations **)
local
	open ExampleMachines
	val unitToString = (fn () => "()")
	fun simulate_unit machine optcount = print (simulate unitToString machine optcount ^ "\n")
	fun simulate_int  machine optcount = print (simulate Int.toString machine optcount ^ "\n")
in
	val () = print "Simulate incrementer...\n\n"
	val () = simulate_unit incrementer NONE
	val () = print "\nSimulate Busy Beaver...\n\n"
	val () = simulate_unit busybeaver NONE
	val () = print "\nSimulate Sorting...\n\n"
	val () = simulate_int sorting NONE
end
