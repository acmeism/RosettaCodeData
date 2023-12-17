let rec common_prefix xs ys = match xs, ys with
  | x :: xs, y :: ys when x = y -> x :: common_prefix xs ys
  | _ -> []

let common_prefix_all = function
  | x :: xs -> List.fold_left common_prefix x xs
  | _ -> []

let common_ancestor ~sep paths =
  List.map Str.(split_delim (regexp_string sep)) paths
  |> common_prefix_all
  |> String.concat sep

let _ = assert begin
  common_ancestor ~sep:"/" [
    "/home/user1/tmp/coverage/test";
    "/home/user1/tmp/covert/operator";
    "/home/user1/tmp/coven/members";
  ] = "/home/user1/tmp"
end
