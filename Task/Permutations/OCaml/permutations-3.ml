let rec pr_perm k n l =
   let a, b = let c = k/n in c, k-(n*c) in
   let e = List.nth l b in
   let rec sub e = function
      | [] -> failwith "sub"
      | h :: t -> if h = e then t else h :: sub e t in
   (Printf.printf " %d" e; if n > 1 then pr_perm a (n-1) (sub e l))

let show_perms l =
   let n = List.length l in
   let rec fact n = if n < 3 then n else n * fact (n-1) in
   for i = 0 to (fact n)-1 do
      pr_perm i n l;
      print_newline()
   done

let () = show_perms [1;2;3;4]
