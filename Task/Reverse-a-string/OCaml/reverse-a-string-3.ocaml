let rec revs_aux strin list index =
  if List.length list = String.length strin
  then String.concat "" list
  else revs_aux strin ((String.sub strin index 1)::list) (index+1)

let revs s = revs_aux s [] 0

let () =
  print_endline (revs "Hello  World!")
