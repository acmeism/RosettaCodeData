let nav_list_of_list = function
  | hd::tl -> [], hd, tl
  | [] -> invalid_arg "empty list"

let current = function
  | _, item, _ -> item

let next = function
  | prev, item, next::next_tl ->
      item::prev, next, next_tl
  | _ ->
      failwith "end of nav_list reached"

let prev = function
  | prev::prev_tl, item, next ->
      prev_tl, prev, item::next
  | _ ->
      failwith "begin of nav_list reached"
