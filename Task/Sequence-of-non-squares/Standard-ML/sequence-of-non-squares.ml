- fun nonsqr n = n + round (Math.sqrt (real n));
val nonsqr = fn : int -> int
- List.tabulate (23, nonsqr);
val it = [0,2,3,5,6,7,8,10,11,12,13,14,...] : int list
- let fun loop i = if i = 1000000 then true
                                  else let val j = Math.sqrt (real (nonsqr i)) in
                                         Real.!= (j, Real.realFloor j) andalso
                                           loop (i+1)
                                       end in
    loop 1
  end;
val it = true : bool
