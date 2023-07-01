let make_list separator =
  let counter = ref 1 in

  let make_item item =
    let result = string_of_int !counter ^ separator ^ item ^ "\n" in
    incr counter;
    result
  in

  make_item "first" ^ make_item "second" ^ make_item "third"

let () =
  print_string (make_list ". ")
