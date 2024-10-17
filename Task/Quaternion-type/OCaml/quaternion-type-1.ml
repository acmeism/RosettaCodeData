type quaternion = {a: float; b: float; c: float; d: float}

let norm q = sqrt (q.a**2.0 +.
                   q.b**2.0 +.
                   q.c**2.0 +.
                   q.d**2.0 )

let floatneg r = ~-. r  (* readability *)

let negative q =
  {a = floatneg q.a;
   b = floatneg q.b;
   c = floatneg q.c;
   d = floatneg q.d }

let conjugate q =
  {a = q.a;
   b = floatneg q.b;
   c = floatneg q.c;
   d = floatneg q.d }

let addrq r q = {q with a = q.a +. r}

let addq q1 q2 =
  {a = q1.a +. q2.a;
   b = q1.b +. q2.b;
   c = q1.c +. q2.c;
   d = q1.d +. q2.d  }

let multrq r q =
  {a = q.a *. r;
   b = q.b *. r;
   c = q.c *. r;
   d = q.d *. r  }

let multq q1 q2 =
        {a = q1.a*.q2.a -. q1.b*.q2.b -. q1.c*.q2.c -. q1.d*.q2.d;
         b = q1.a*.q2.b +. q1.b*.q2.a +. q1.c*.q2.d -. q1.d*.q2.c;
         c = q1.a*.q2.c -. q1.b*.q2.d +. q1.c*.q2.a +. q1.d*.q2.b;
         d = q1.a*.q2.d +. q1.b*.q2.c -. q1.c*.q2.b +. q1.d*.q2.a  }

let qmake a b c d = {a;b;c;d} (* readability omitting a= b=... *)

let qstring q =
  Printf.sprintf "(%g, %g, %g, %g)" q.a q.b q.c q.d ;;

(* test data *)
let q  = qmake 1.0  2.0  3.0  4.0
let q1 = qmake 2.0  3.0  4.0  5.0
let q2 = qmake 3.0  4.0  5.0  6.0
let r  = 7.0

let () = (* written strictly to spec *)
  let pf = Printf.printf in
  pf "starting with data q=%s, q1=%s,  q2=%s, r=%g\n" (qstring q) (qstring q1) (qstring q2) r;
  pf "1. norm of      q     = %g \n" (norm q) ;
  pf "2. negative of  q     = %s \n" (qstring (negative q));
  pf "3. conjugate of q     = %s \n" (qstring (conjugate q));
  pf "4. adding r to q      = %s \n" (qstring (addrq r q));
  pf "5. adding q1 and q2   = %s \n" (qstring (addq q1 q2));
  pf "6. multiply r and q   = %s \n" (qstring (multrq r q));
  pf "7. multiply q1 and q2 = %s \n" (qstring (multq q1 q2));
  pf "8. instead q2 * q1    = %s \n" (qstring (multq q2 q1));
  pf "\n";
