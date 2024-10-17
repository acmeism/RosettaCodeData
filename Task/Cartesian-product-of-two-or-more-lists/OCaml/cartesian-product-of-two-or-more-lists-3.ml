let cart_prod l1 l2 =
  List.fold_left (fun acc1 ele1 ->
    List.fold_left (fun acc2 ele2 -> (ele1,ele2)::acc2) acc1 l2) [] l1 ;;

cart_prod [1; 2; 3] ['a'; 'b'; 'c'] ;;
(*- : (int * char) list = [(3, 'c'); (3, 'b'); (3, 'a'); (2, 'c'); (2, 'b'); (2, 'a'); (1, 'c'); (1, 'b'); (1, 'a')]*)
cart_prod [1; 2; 3] [] ;;
(*- : ('a * int) list = [] *)
