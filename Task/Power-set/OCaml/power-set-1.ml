module PowerSet(S: Set.S) =
struct

  include Set.Make (S)

  let map f s =
    let work x r = add (f x) r in
    fold work s empty
  ;;

  let powerset s =
    let base = singleton (S.empty) in
    let work x r = union r (map (S.add x) r) in
    S.fold work s base
  ;;

end;; (* PowerSet *)
