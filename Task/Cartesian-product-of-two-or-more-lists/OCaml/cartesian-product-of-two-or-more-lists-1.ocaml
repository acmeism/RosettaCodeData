let rec product l1 l2 =
    match l1, l2 with
    | [], _ | _, [] -> []
    | h1::t1, h2::t2 -> (h1,h2)::(product [h1] t2)@(product t1 l2)
;;

product [1;2] [3;4];;
(*- : (int * int) list = [(1, 3); (1, 4); (2, 3); (2, 4)]*)
product [3;4] [1;2];;
(*- : (int * int) list = [(3, 1); (3, 2); (4, 1); (4, 2)]*)
product [1;2] [];;
(*- : (int * 'a) list = []*)
product [] [1;2];;
(*- : ('a * int) list = []*)
