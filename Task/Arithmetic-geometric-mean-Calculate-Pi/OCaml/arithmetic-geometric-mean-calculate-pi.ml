let limit = 10000 and n = 2800
let x = Array.make (n+1) 2000

let rec g j sum =
  if j < 1 then sum else
    let sum = sum * j + limit * x.(j) in
    x.(j) <- sum mod (j * 2 - 1);
    g (j - 1) (sum / (j * 2 - 1))

let rec f i carry =
  if i = 0 then () else
    let sum = g i 0 in
    Printf.printf "%04d" (carry + sum / limit);
    f (i - 14) (sum mod limit)

let () =
  f n 0;
  print_newline()
