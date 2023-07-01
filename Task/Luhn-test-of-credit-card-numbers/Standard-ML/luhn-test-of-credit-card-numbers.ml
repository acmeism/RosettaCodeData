local
  fun revDigits 0 = []
    | revDigits n = (n mod 10) :: revDigits (n div 10)

  fun digitSum n = if n > 9 then digitSum (n div 10 + n mod 10)
                            else n

  fun luhn_sum []  = 0
    | luhn_sum [d] = d
    | luhn_sum (d::d'::ds) = d + digitSum (2*d') + luhn_sum ds
in
  fun luhn_test n = luhn_sum (revDigits n) mod 10 = 0

  val res = map luhn_test [49927398716, 49927398717, 1234567812345678, 1234567812345670];
end;

(*
[opening file "luhn.sml"]
> val luhn_test = fn : int -> bool
  val res = [true, false, false, true] : bool list
[closing file "luhn.sml"]
*)
