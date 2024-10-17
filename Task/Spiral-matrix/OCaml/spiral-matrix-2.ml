let spiral n =
   let ar = Array.make_matrix n n (-1) in
   let out i = i < 0 || i >= n in
   let too_far (x,y) = out x || out y || ar.(x).(y) >= 0 in
   let step x y (dx,dy) = (x+dx,y+dy) in
   let turn (i,j) = (j,-i) in
   let rec iter (x,y) d i =
      ar.(x).(y) <- i;
      if i < n*n-1 then
         let d' = if too_far (step x y d) then turn d else d in
         iter (step x y d') d' (i+1) in
   (iter (0,0) (0,1) 0; ar)

let show =
   Array.iter (fun v -> Array.iter (Printf.printf " %2d") v; print_newline())

let _ = show (spiral 5)
