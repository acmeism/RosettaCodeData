let uniq l =
  let rec tail_uniq a l =
    match l with
      | [] -> a
      | hd::tl -> tail_uniq (hd::a) (List.filter (fun x -> x  != hd) tl) in
  tail_uniq [] l
