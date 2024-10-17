let squarefree (number: int) : bool =
    let max = Float.of_int number |> sqrt |> Float.to_int |> (fun x -> x + 2) in
    let rec inner i number2 =
        if i == max
        then true
        else if number2 mod (i*i) == 0
             then false
             else inner (i+1) number2
    in inner 2 number
;;

let list_squarefree_integers (x, y) =
    let rec inner start finish output =
        if start == finish
        then output
        else if squarefree start
             then inner (start+1) finish (start :: output)
             else inner (start+1) finish output
    in inner x y []
;;

let print_squarefree_integers (x, y) =
    let squarefrees_unrev = list_squarefree_integers (x, y) in
    let squarefrees = List.rev squarefrees_unrev in
    let rec inner sfs i count =
        match sfs with
          []    -> count
        | h::t  -> (if (i+1) mod 5 == 0 then (Printf.printf "%d\n" h) else (Printf.printf "%d " h); inner t (i+1) (count+1);)
    in Printf.printf "\n\nTotal count of square-free numbers between %d and %d: %d\n" x y (inner squarefrees 0 0)
;;

let () =
    print_squarefree_integers (1, 146);
    print_squarefree_integers (1000000000000, 1000000000146)
;;
