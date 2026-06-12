# let rec rotate n = function
    | h :: (_ :: _ as t) when n > 0 -> rotate (pred n) (t @ [h])
    | l -> l
  ;;
val rotate : int -> 'a list -> 'a list = <fun>
# rotate 3 [1; 2; 3; 4; 5; 6; 7; 8; 9] ;;
- : int list = [4; 5; 6; 7; 8; 9; 1; 2; 3]
