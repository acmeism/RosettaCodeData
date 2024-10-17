let lis cmp list =
  let pile_tops = Array.make (List.length list) [] in
  let bsearch_piles x len =
    let rec aux lo hi =
      if lo > hi then
        lo
      else
        let mid = (lo + hi) / 2 in
        if cmp (List.hd pile_tops.(mid)) x < 0 then
          aux (mid+1) hi
        else
          aux lo (mid-1)
    in
      aux 0 (len-1)
  in
  let f len x =
    let i = bsearch_piles x len in
    pile_tops.(i) <- x :: if i = 0 then [] else pile_tops.(i-1);
    if i = len then len+1 else len
  in
  let len = List.fold_left f 0 list in
  List.rev pile_tops.(len-1)
