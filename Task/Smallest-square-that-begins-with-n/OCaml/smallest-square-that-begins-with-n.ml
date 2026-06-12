let rec is_prefix a b =
  if b > a then is_prefix a (b/10) else a = b

let rec smallest ?(i=1) n =
  let square = i*i in
  if is_prefix n square then square else smallest n ~i:(succ i)

let _ =
  for n = 1 to 49 do
    Printf.printf "%d%c" (smallest n) (if n mod 10 = 0 then '\n' else '\t')
  done
