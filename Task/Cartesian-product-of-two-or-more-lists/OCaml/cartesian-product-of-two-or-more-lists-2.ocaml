let product' l1 l2 =
    let rec aux ~acc l1' l2' =
        match l1', l2' with
        | [], _ | _, [] -> acc
        | h1::t1, h2::t2 ->
            let acc = (h1,h2)::acc in
            let acc = aux ~acc t1 l2' in
            aux ~acc [h1] t2
    in aux [] l1 l2
;;

product' [1;2] [3;4];;
(*- : (int * int) list = [(1, 4); (2, 4); (2, 3); (1, 3)]*)
product' [3;4] [1;2];;
(*- : (int * int) list = [(3, 2); (4, 2); (4, 1); (3, 1)]*)
product' [1;2] [];;
(*- : (int * 'a) list = []*)
product' [] [1;2];;
(*- : ('a * int) list = []*)
