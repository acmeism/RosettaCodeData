let rec permutations l =
   let n = List.length l in
   if n = 1 then [l] else
   let rec sub e = function
      | [] -> failwith "sub"
      | h :: t -> if h = e then t else h :: sub e t in
   let rec aux k =
      let e = List.nth l k in
      let subperms = permutations (sub e l) in
      let t = List.map (fun a -> e::a) subperms in
      if k < n-1 then List.rev_append t (aux (k+1)) else t in
   aux 0;;

let print l = List.iter (Printf.printf " %d") l; print_newline() in
List.iter print (permutations [1;2;3;4])
