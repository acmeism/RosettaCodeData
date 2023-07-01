(* see http://oeis.org/A005150 *)

let look_and_say s =
let n = String.length s
and buf = Buffer.create 0
and prev = ref s.[0]
and count = ref 0 in
let append () = Buffer.add_char buf (char_of_int (48 + !count));
                Buffer.add_char buf !prev in
String.iter (fun c ->
   if c = !prev then incr count else
   begin
      append ();
      prev := c;
      count := 1
   end
) s;
append ();
Buffer.contents buf;;

(* what about length of successive strings ? *)
let iter f a n =
let rec aux r n v = if n = 0
                    then List.rev(r::v)
                    else aux (f r) (n - 1) (r::v) in
aux a n [];;

let las = iter look_and_say "1";;

(* the first sixty terms *)

List.map (String.length) (las 59);;
(*
   [1; 2; 2; 4; 6; 6; 8; 10; 14; 20; 26; 34; 46; 62; 78; 102; 134; 176; 226;
    302; 408; 528; 678; 904; 1182; 1540; 2012; 2606; 3410; 4462; 5808; 7586;
    9898; 12884; 16774; 21890; 28528; 37158; 48410; 63138; 82350; 107312;
    139984; 182376; 237746; 310036; 403966; 526646; 686646; 894810; 1166642;
    1520986; 1982710; 2584304; 3369156; 4391702; 5724486; 7462860; 9727930;
    12680852]
*)

(* see http://oeis.org/A005341 *)
