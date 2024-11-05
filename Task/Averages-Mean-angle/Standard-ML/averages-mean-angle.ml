(* some helper functions *)
val sum = List.foldl (op +) 0.0
val tau = 2.0 * Math.pi
fun deg2rad x = (x / 360.0) * tau
fun rad2deg x = (x / tau) * 360.0

fun printList' [] = print "\b\b]"
  | printList' (x::xs) = (print (Int.toString x); print ", "; printList' xs)
fun printList [] = print "[]"
  | printList xs = (print "["; printList' xs)

(* the main function *)
fun meanAngle xs =
  let
    val realLen = Real.fromInt (length xs)
  in
    Math.atan2((sum (map Math.sin xs))/realLen, (sum (map Math.cos xs))/realLen)
  end

(* try it out *)
val angless = [[350, 10], [90, 180, 270, 360], [10, 20, 30]]

fun doAngleMeans [] = ()
  | doAngleMeans (angles::rest) =
    let
      val rads = map (deg2rad o Real.fromInt) angles
      val _ = print "Mean angle of: "
      val _ = printList angles
      val _ = print " = "
      val _ = print (Int.toString (Real.round (rad2deg (meanAngle rads))))
      val _ = print "\n"
    in
      doAngleMeans rest
    end
