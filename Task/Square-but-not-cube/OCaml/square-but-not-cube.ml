let rec fN n g phi =
  if phi < 31 then
    match compare (n*n) (g*g*g) with
    | -1 -> Printf.printf "%d\n" (n*n); fN (n+1) g (phi+1)
    |  0 -> Printf.printf "%d cube and square\n" (n*n); fN (n+1) (g+1) phi
    |  1 -> fN n (g+1) phi
    | _ -> assert false
;;

fN 1 1 1
