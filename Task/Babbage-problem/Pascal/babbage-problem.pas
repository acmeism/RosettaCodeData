program BabbageProblem;
(* Anything bracketed off like this is an explanatory comment. *)
var n : longint; (* The VARiable n can hold a 'long', ie large, INTeger. *)
begin
    n := 2; (* Start with n equal to 2. *)
    repeat
        n := n + 2 (* Increase n by 2. *)
    until (n * n) mod 1000000 = 269696;
(* 'n * n' means 'n times n'; 'mod' means 'modulo'. *)
    write(n)
end.
