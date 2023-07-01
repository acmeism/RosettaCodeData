(* Load required Modules for Moscow ML *)
load "Int";
load "Random";


(* Mutable Matrix *)
signature MATRIX =
sig
	type 'a matrix
	val construct : 'a -> int * int -> 'a matrix
	val size : 'a matrix -> int * int
	val get : 'a matrix -> int * int -> 'a
	val set : 'a matrix -> int * int -> 'a -> unit
end

structure Matrix :> MATRIX =
struct
	(* Array of rows, where the rows are a array of 'a *)
	type 'a matrix = 'a Array.array Array.array

	fun 'a construct (a : 'a) (width, height) : 'a matrix =
		if width < 1 orelse height < 1
			then raise Subscript
			else Array.tabulate (height, fn _ => Array.tabulate (width, fn _ => a))
	
	fun size b =
		let
			val firstrow = Array.sub (b, 0)
		in
			(Array.length firstrow, Array.length b)
		end

	
	fun get b (x, y) = Array.sub (Array.sub (b, y), x)

	fun set b (x, y) v = Array.update (Array.sub (b, y), x, v)
end

signature P15BOARD =
sig
	type board
	datatype direction = North | East | South | West

	val construct : int * int -> board
	val emptyField : board -> int * int
	val get : board -> int * int -> int option
	val size : board -> int * int

	exception IllegalMove
	val moves : board -> int list
	val move : board -> int -> unit

	val issolved : board -> bool
end

(* Game Logic and data *)

structure Board :> P15BOARD =
struct
	(* Matrix + empty Field position *)
	type board = int option Matrix.matrix * (int * int) ref
	
	datatype direction = North | East | South | West

	exception IllegalMove

	fun numberat width (x, y) = (y*width + x + 1)

	fun construct (width, height) =
		let
			val emptyBoard : int option Matrix.matrix = Matrix.construct NONE (width, height)
		in
			(* Fill the board with numbers *)
			List.tabulate (height, fn y => List.tabulate (width, fn x =>
					Matrix.set emptyBoard (x, y) (SOME (numberat width (x, y)))));
			(* Clear the last field *)
			Matrix.set emptyBoard (width-1, height-1) NONE;
			(* Return the board *)
			(emptyBoard, ref (width-1, height-1))
		end

	fun emptyField (_, rfield) = !rfield

	fun get (mat, _) (x, y) = Matrix.get mat (x, y)

	fun size (mat, _) = Matrix.size mat

	(* toggle the empty field with a given field *)
	fun toggle (mat, rpos) pos =
		let
			val pos' = !rpos
			val value = Matrix.get mat pos
		in
			Matrix.set mat pos NONE;
			Matrix.set mat pos' value;
			rpos := pos
		end

	(* Get list of positions of the neighbors of a given field *)
	fun neighbors mat (x, y) : (int * int) list =
		let
			val (width, height) = Matrix.size mat
			val directions = [(x, y-1), (x+1, y), (x, y+1), (x-1, y)]
		in
			List.mapPartial (fn pos => SOME (Matrix.get mat pos; pos) handle Subscript => NONE) directions
		end
	
	fun moves (mat, rpos) =
		let
			val neighbors = neighbors mat (!rpos)
		in
			map (fn pos => valOf (Matrix.get mat pos)) neighbors
		end
		
	fun move (mat, rpos) m =
		let
			val (hx, hy) = !rpos
			val neighbors = neighbors mat (hx, hy)
			val optNeighbor = List.find (fn pos => SOME m = Matrix.get mat pos) neighbors
		in
			if isSome optNeighbor
			then
				toggle (mat, rpos) (valOf optNeighbor)
			else
				raise IllegalMove
		end

	fun issolved board =
		let
			val (width, height) = size board
			val xs = List.tabulate (width,  fn x => x)
			val ys = List.tabulate (height, fn y => y)
		in
			List.all (fn x => List.all (fn y => (x + 1 = width andalso y + 1 = height) orelse get board (x, y) = SOME (numberat width (x,y))) ys) xs
		end
end

(* Board Shuffle *)
signature BOARDSHUFFLE =
sig
	val shuffle : Board.board -> int -> unit
end

structure Shuffle :> BOARDSHUFFLE =
struct
	(*
	 * Note: Random Number Interfaces are different in SML/NJ and Moscow ML. Comment out the corresponding version:
	 *)

	(*
	(* SML/NJ - Version *)
	val time = Time.now ()
	val timeInf = Time.toMicroseconds time
	val timens = Int.fromLarge (LargeInt.mod (timeInf, 1073741823));
	val rand = Random.rand (timens, timens)

	fun next n = Random.randRange (0, n) rand
	*)

	(* Moscow ML - Version *)
	val generator = Random.newgen ()
	fun next n = Random.range (0, n) generator


	fun shuffle board 0 = if (Board.issolved board) then shuffle board 1 else ()
	  | shuffle board n =
	  	let
			val moves = Board.moves board
			val move  = List.nth (moves, next (List.length moves - 1))
		in
			Board.move board move;
			shuffle board (n-1)
		end
end


(* Console interface *)

signature CONSOLEINTERFACE =
sig
	val start : unit -> unit
	val printBoard : Board.board -> unit
end

structure Console :> CONSOLEINTERFACE =
struct
	fun cls () = print "\^[[1;1H\^[[2J"

	fun promptNumber prompt =
		let
			val () = print prompt
			(* Input + "\n" *)
			val line   = valOf (TextIO.inputLine TextIO.stdIn)
			val length = String.size line
			val input  = String.substring (line, 0, length - 1)
			val optnum = Int.fromString input
		in
			if isSome optnum
				then valOf optnum
				else (print "Input is not a number.\n"; promptNumber prompt)
		end

	fun fieldToString (SOME x) = Int.toString x
	  | fieldToString (NONE  ) = ""

	fun boardToString board =
		let
			val (width, height) = Board.size board
			val xs = List.tabulate (width,  fn x => x)
			val ys = List.tabulate (height, fn y => y)
		in
			foldl (fn (y, str) => (foldl (fn (x, str') => str' ^ (fieldToString (Board.get board (x, y))) ^ "\t") str xs) ^ "\n") "" ys
		end
	
	fun printBoard board = print (boardToString board)


	fun loop board =
		let
			val rvalidInput = ref false
			val rinput      = ref 42
			val () = cls ()
			val () = printBoard board
		in
			(* Ask for a move and repeat until it is a valid move *)
			while (not (!rvalidInput)) do
				(
					rinput := promptNumber "Input the number to move: ";
					Board.move board (!rinput);
					rvalidInput := true
				) handle Board.IllegalMove => print "Illegal move!\n"
		end

	
	fun start () =
		let
			val () = cls ()
			val () = print "Welcome to nxm-Puzzle!\n"
			val (width, height) = (promptNumber "Enter the width: ", promptNumber "Enter the height: ")
			val diff = (promptNumber "Enter the difficulty (number of shuffles): ")
			val board = Board.construct (width, height)
		in
			Shuffle.shuffle board diff;
			while (not (Board.issolved board)) do loop board;
			print "Solved!\n"
		end
end


val () = Console.start()
