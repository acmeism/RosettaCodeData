let bind : 'a list -> ('a -> 'b list) -> 'b list =
  fun l f -> List.flatten (List.map f l)

let return x = [x]
