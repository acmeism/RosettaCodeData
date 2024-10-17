open Core.Std
open Option.Monad_infix

let rec egcd a b =
   if b = 0 then (1, 0)
   else
      let q = a/b and r = a mod b in
      let (s, t) = egcd b r in
         (t, s - q*t)


let mod_inv a b =
   let (x, y) = egcd a b in
      if a*x + b*y = 1 then Some x else None


let calc_inverses ns ms =
   let rec list_inverses ns ms l =
      match (ns, ms) with
         | ([], []) -> Some l
         | ([], _)
         | (_, []) -> assert false
         | (n::ns, m::ms) ->
            let inv = mod_inv n m in
               match inv with
                  | None -> None
                  | Some v -> list_inverses ns ms (v::l)
   in
      list_inverses ns ms [] >>= fun l -> Some (List.rev l)


let chinese_remainder congruences =
   let (residues, modulii) = List.unzip congruences in
   let mod_pi = List.reduce_exn modulii ~f:( * ) in
   let crt_modulii = List.map modulii ~f:(fun m -> mod_pi / m) in
   calc_inverses crt_modulii modulii >>=
      fun inverses ->
         Some (List.map3_exn residues inverses crt_modulii ~f:(fun a b c -> a*b*c)
               |> List.reduce_exn ~f:(+)
               |> fun n -> let n' = n mod mod_pi in if n' < 0 then n' + mod_pi else n')
