(* A simple function to generate the sequence
   Nigel Galloway: January 31st., 2017 *)
type G = {d:int;x:int;b:int;f:int}
let N n g =
  {(max (n-g) n) .. (min (g-n) g)} |> Seq.collect(fun d->{(max (d+n+n) (n+n))..(min (g+g) (d+g+g))}           |> Seq.collect(fun x ->
  seq{for a in n .. g do for b in n .. g do if (a+b) = x then for c in n .. g do if (b+c+d) = x then yield b} |> Seq.collect(fun b ->
  seq{for f in n .. g do for G in n .. g do if (f+G) = x then for e in n .. g do if (f+e+d) = x then yield f} |> Seq.map(fun f -> {d=d;x=x;b=b;f=f}))))
