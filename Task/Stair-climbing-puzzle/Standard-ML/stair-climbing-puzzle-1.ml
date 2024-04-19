(*
 * val step : unit -> bool
 * This is a stub for a function which returns true if successfully climb a step or false otherwise.
 *)
fun step() = true

(*
 * val step_up : unit -> bool
 *)
fun step_up() = step() orelse (step_up() andalso step_up())
