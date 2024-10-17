(** The result is the size given in word.
  The word size in octet can be found with (Sys.word_size / 8).
  (The size of all the datas in OCaml is at least one word, even chars and bools.)
*)
let sizeof v =
  let rec rec_size d r =
    if List.memq r d then (1, d) else
    if not(Obj.is_block r) then (1, r::d) else
    if (Obj.tag r) = (Obj.double_tag) then (2, r::d) else
    if (Obj.tag r) = (Obj.string_tag) then (Obj.size r, r::d) else
    if (Obj.tag r) = (Obj.object_tag) ||
       (Obj.tag r) = (Obj.closure_tag)
    then invalid_arg "please only provide datas"
    else
      let len = Obj.size r in
      let rec aux d sum i =
        if i >= len then (sum, r::d) else
        let this = Obj.field r i in
        let this_size, d = rec_size d this in
        aux d (sum + this_size) (i+1)
      in
      aux d (1) 0
  in
  fst(rec_size [] (Obj.repr v))
;;
