let rec ssort = function
    [] -> []
    | x::xs ->
        let min, rest =
            List.fold (fun (min,acc) x ->
                             if h<min then (h, min::acc)
                             else (min, h::acc))
              (x, []) xs
        in min::ssort rest
