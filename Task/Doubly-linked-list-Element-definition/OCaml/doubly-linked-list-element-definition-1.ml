type 'a dlink = {
  mutable data: 'a;
  mutable next: 'a dlink option;
  mutable prev: 'a dlink option;
}

let dlink_of_list li =
  let f prev_dlink x =
    let dlink = {
      data = x;
      prev = None;
      next = prev_dlink }
    in
    begin match prev_dlink with
    | None -> ()
    | Some prev_dlink ->
        prev_dlink.prev <- Some dlink
    end;
    Some dlink
  in
  List.fold_left f None (List.rev li)
;;

let list_of_dlink =
  let rec aux acc = function
  | None -> List.rev acc
  | Some{ data = d;
          prev = _;
          next = next } -> aux (d::acc) next
  in
  aux []
;;

let iter_forward_dlink f =
  let rec aux = function
  | None -> ()
  | Some{ data = d;
          prev = _;
          next = next } -> f d; aux next
  in
  aux
;;
