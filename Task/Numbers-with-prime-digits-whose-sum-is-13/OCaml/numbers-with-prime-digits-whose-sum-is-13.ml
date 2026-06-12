let prime_digits_13 =
  let digits = [2; 3; 5; 7] in
  let rec next ds ns = function
    | [] -> if ns = [] then [] else next digits [] (List.rev ns)
    | (n, r) :: cs' as cs ->
        match ds with
        | d :: ds' when d < r -> next ds' (((n + d) * 10, r - d) :: ns) cs
        | d :: ds' when d = r -> n + d :: next digits ns cs'
        | _ -> next digits ns cs'
  in next digits [] [0, 13]

let () =
  List.map string_of_int prime_digits_13 |> String.concat " " |> print_endline
