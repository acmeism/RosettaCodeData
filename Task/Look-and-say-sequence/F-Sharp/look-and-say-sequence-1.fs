let rec brk p lst =
  match lst with
  | [] -> (lst, lst)
  | x::xs ->
    if p x
    then ([], lst)
    else
      let (ys, zs) = brk p xs
      (x::ys, zs)

let span p lst = brk (not << p) lst

let rec groupBy eq lst =
  match lst with
  | [] ->  []
  | x::xs ->
    let (ys,zs) = span (eq x) xs
	(x::ys)::groupBy eq zs

let group lst : list<list<'a>> when 'a : equality = groupBy (=) lst
