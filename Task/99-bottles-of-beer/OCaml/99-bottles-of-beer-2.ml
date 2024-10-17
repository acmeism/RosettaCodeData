let verse n =
    let
        line2 = function
            | 0 -> "No more bottles of beer"
            | 1 -> "1 bottle of beer"
            | n -> string_of_int n ^ " bottles of beer"
    in
        let
            line1or4 y = line2 y ^ " on the wall"
        in
            let
                line3 = function
                | 1 -> "Take it down, pass it around"
                | _ -> "Take one down, pass it around"
            in
                line1or4 n ^ "\n" ^
                line2 n ^ "\n" ^
                line3 n ^ "\n" ^
                line1or4 (n-1) ^ "\n";;

let rec beer n =
    print_endline (verse n);
    if n > 1 then beer (n-1);;

beer 99;;
