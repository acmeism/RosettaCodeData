module PatienceSortFn (Ord : Set.OrderedType) : sig
    val patience_sort : Ord.t list -> Ord.t list
  end = struct

  module PilesSet = Set.Make
    (struct
       type t = Ord.t list
       let compare x y = Ord.compare (List.hd x) (List.hd y)
     end);;

  let sort_into_piles list =
    let piles = Array.make (List.length list) [] in
    let bsearch_piles x len =
      let rec aux lo hi =
        if lo > hi then
          lo
        else
          let mid = (lo + hi) / 2 in
          if Ord.compare (List.hd piles.(mid)) x < 0 then
            aux (mid+1) hi
          else
            aux lo (mid-1)
      in
        aux 0 (len-1)
    in
    let f len x =
      let i = bsearch_piles x len in
      piles.(i) <- x :: piles.(i);
      if i = len then len+1 else len
    in
    let len = List.fold_left f 0 list in
    Array.sub piles 0 len

  let merge_piles piles =
    let pq = Array.fold_right PilesSet.add piles PilesSet.empty in
    let rec f pq acc =
      if PilesSet.is_empty pq then
        acc
      else
        let elt = PilesSet.min_elt pq in
        match elt with
          [] -> failwith "Impossible"
        | x::xs ->
          let pq' = PilesSet.remove elt pq in
          f (if xs = [] then pq' else PilesSet.add xs pq') (x::acc)
    in
    List.rev (f pq [])

  let patience_sort n =
    merge_piles (sort_into_piles n)
end
