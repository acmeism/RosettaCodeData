(* implementation conforming to signature *)
module Frac : RATIO =
   struct
      open Big_int

      type t = { num : big_int; den : big_int }

      (* short aliases for big_int values and functions *)
      let zero, one = zero_big_int, unit_big_int
      let big, to_int, eq = big_int_of_int, int_of_big_int, eq_big_int
      let (+~), (-~), ( *~) = add_big_int, sub_big_int, mult_big_int

      (* helper function *)
      let rec norm ({num=n;den=d} as k) =
         if lt_big_int d zero then
           norm {num=minus_big_int n;den=minus_big_int d}
         else
         let rec hcf a b =
           let q,r = quomod_big_int a b in
           if eq r zero then b else hcf b r in
         let f = hcf n d in
         if eq f one then k else
            let div = div_big_int in
            { num=div n f; den = div d f } (* inefficient *)

      (* public functions *)
      let frac a b = norm { num=big a; den=big b }

      let from_int a = norm { num=big a; den=one }

      let is_int {num=n; den=d} =
         eq d one ||
         eq (mod_big_int n d) zero

      let to_string ({num=n; den=d} as r) =
         let r1 = norm r in
         let str = string_of_big_int in
         if is_int r1 then
            str (r1.num)
         else
            str (r1.num) ^ "/" ^ str (r1.den)

      let cmp a b =
         let a1 = norm a and b1 = norm b in
         compare_big_int (a1.num*~b1.den) (b1.num*~a1.den)

      let ( */ ) {num=n1; den=d1} {num=n2; den=d2} =
         norm { num = n1*~n2; den = d1*~d2 }

      let ( // ) {num=n1; den=d1} {num=n2; den=d2} =
         norm { num = n1*~d2; den = d1*~n2 }

      let ( +/ ) {num=n1; den=d1} {num=n2; den=d2} =
         norm { num = n1*~d2 +~ n2*~d1; den = d1*~d2 }

      let ( -/ ) {num=n1; den=d1} {num=n2; den=d2} =
         norm { num = n1*~d2 -~ n2*~d1; den = d1*~d2 }
   end
