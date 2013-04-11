let rref m =
   let nr, nc = Array.length m, Array.length m.(0) in
   let add r s k =
      for i = 0 to nc-1 do m.(r).(i) <- m.(r).(i) +. m.(s).(i)*.k done in
   for c = 0 to min (nc-1) (nr-1) do
      for r = c+1 to nr-1 do
         if abs_float m.(c).(c) < abs_float m.(r).(c) then
         let v = m.(r) in (m.(r) <- m.(c); m.(c) <- v)
      done;
      let t = m.(c).(c) in
      if t <> 0.0 then
      begin
         for r = 0 to nr-1 do if r <> c then add r c (-.m.(r).(c)/.t) done;
         for i = 0 to nc-1 do m.(c).(i) <- m.(c).(i)/.t done
      end
   done;;

let mat = [|
             [|  1.0;  2.0;  -.1.0;  -.4.0;|];
             [|  2.0;  3.0;  -.1.0; -.11.0;|];
             [|-.2.0;  0.0;  -.3.0;   22.0;|]
          |] in
let pr v = Array.iter (Printf.printf " %9.4f") v; print_newline() in
let show = Array.iter pr in
   show mat;
   print_newline();
   rref mat;
   show mat
