(* val _insert : 'a dlink -> 'a dlink -> unit *)
let _insert anchor newlink =
  newlink.next <- anchor.next;
  newlink.prev <- Some anchor;
  begin match newlink.next with
  | None -> ()
  | Some next ->
      next.prev <-Some newlink;
  end;
  anchor.next <- Some newlink;;

(* val insert : 'a dlink option -> 'a -> unit *)
let insert dl v =
  match dl with
  | (Some anchor) -> _insert anchor {data=v; prev=None; next=None}
  | None  -> invalid_arg "dlink empty";;
