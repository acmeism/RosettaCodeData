(* helper functions *)
val sum = List.foldl (op +) 0.0
fun mean xs = (sum xs) / (Real.fromInt (length xs))

type smastate = int * real list

(* initialize an SMA state with the given period *)
fun smaInit period : smastate = (period, [])

(* update the SMA in the given state with the given number *)
(* returns a tuple containing the new SMA and the new state *)
fun sma (state : smastate) (num : real) : (real * smastate) =
  let
    val (period, buffer) = state
  	val amt = Int.min(1 + List.length buffer, period)
    val newlist = List.take(num::buffer, amt)
  in
  	(mean newlist, (period, newlist))
  end

fun printSMA' _ [] = ()
  | printSMA' state (x::xs) =
    let
      val (n, next) = sma state x
    in
      print ("Added " ^ (Real.toString x) ^ ": SMA=" ^ (Real.toString n) ^ "\n");
      printSMA' next xs
    end

(* print the SMA with given period at each step over the list xs *)
fun printSMA period xs =
  printSMA' (smaInit period) xs
