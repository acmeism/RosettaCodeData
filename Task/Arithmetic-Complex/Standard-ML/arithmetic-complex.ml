(* Signature for complex numbers *)
signature COMPLEX = sig
  type num

  (* creation *)
  val complex : real * real -> num

  (* operations *)
  val negative : num -> num
  val plus : num -> num -> num
  val minus : num -> num -> num
  val times : num -> num -> num
  val invert : num -> num

  (* polar form *)
  val abs : num -> real
  val arg : num -> real

  (* output *)
  val print_number : num -> unit
end;

(* Actual implementation *)
structure Complex :> COMPLEX = struct
  type num = real * real

  fun complex (a, b) = (a, b)

  fun negative (a, b) = (Real.~a, Real.~b)
  fun plus (a1, b1) (a2, b2) = (Real.+ (a1, a2), Real.+(b1, b2))
  fun minus i1 i2 = plus i1 (negative i2)
  fun times (a1, b1) (a2, b2)= (Real.*(a1, a2) - Real.*(b1, b2), Real.*(a1, b2) + Real.*(a2, b1))
  fun invert (a, b) =
    let
      val denom = a * a + b * b
    in
      (a / denom, ~b / denom)
    end

  fun abs (x, y) = Math.sqrt (x*x + y*y)
  fun arg (x, y) = Math.atan2(y, x)

  fun print_number (a, b) =
    print (Real.toString(a) ^ " + " ^ Real.toString(b) ^ "i\n")
end;

val i1 = Complex.complex(1.0,2.0); (* 1 + 2i *)
val i2 = Complex.complex(3.0,4.0); (* 3 + 4i *)

Complex.print_number(Complex.negative(i1)); (* -1 - 2i *)
Complex.print_number(Complex.plus i1 i2); (* 4 + 6i *)
Complex.print_number(Complex.minus i2 i1); (* 2 + 2i *)
Complex.print_number(Complex.times i1 i2); (* -5 + 10i *)
Complex.print_number(Complex.invert i1); (* 1/5 - 2i/5 *)
