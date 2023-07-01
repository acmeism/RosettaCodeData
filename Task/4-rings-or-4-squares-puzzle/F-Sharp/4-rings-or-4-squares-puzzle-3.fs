(* A simple function to generate the sequence with unique values
   Nigel Galloway: January 31st., 2017 *)
type G = {d:int;x:int;b:int;f:int}
let N n g =
  {(max (n-g) n) .. (min (g-n) g)} |> Seq.filter(fun d -> d <> 0) |> Seq.collect(fun d->{(max (d+n+n) (n+n)) .. (min (g+g) (d+g+g))} |> Seq.collect(fun x ->
  seq{for a in n .. g do if a <> d then for b in n .. g do if (a+b) = x && b <> a && b <> d then for c in n .. g do if (b+c+d) = x && c <> d && c <> a && c <> b then yield b} |> Seq.collect(fun b ->
  seq{for f in n .. g do if f <> d && f <> b && f <> (x-b) && f <> (x-d-b) then for G in n .. g do if (f+G) = x && G <> d && G <> b && G <> f && G <> (x-b) && G <> (x-d-b) then for e in n .. g do if (f+e+d) = x && e <> d && e <> b && e <> f && e <> G && e <> (x-b) && e <> (x-d-b) then yield f} |> Seq.map(fun f -> {d=d;x=x;b=b;f=f}))))
