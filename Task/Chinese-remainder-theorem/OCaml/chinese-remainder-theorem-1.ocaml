exception Modular_inverse
let inverse_mod a = function
  | 1 -> 1
  | b -> let rec inner a b x0 x1 =
           if a <= 1 then x1
           else if  b = 0 then raise Modular_inverse
           else inner b (a mod b) (x1 - (a / b) * x0) x0 in
         let x = inner a b 0 1 in
         if x < 0 then x + b else x

let chinese_remainder_exn congruences =
  let mtot = congruences
             |> List.map (fun (_, x) -> x)
             |> List.fold_left ( *) 1 in
   (List.fold_left (fun acc (r, n) ->
                  acc + r * inverse_mod (mtot / n) n * (mtot / n)
                ) 0 congruences)
             mod mtot

let chinese_remainder congruences =
   try Some (chinese_remainder_exn congruences)
   with modular_inverse -> None
