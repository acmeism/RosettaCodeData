let rec ssort = function
    [] -> []
    | x::xs ->
        let min, rest =
            List.fold (fun (min,acc) x ->
                             if x<min then (x, min::acc)
                             else (min, x::acc))
              (x, []) xs
        in min::ssort rest
