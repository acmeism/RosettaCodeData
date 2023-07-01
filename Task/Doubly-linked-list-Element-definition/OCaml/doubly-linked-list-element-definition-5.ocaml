# let nl = nav_list_of_list [1;2;3;4;5] ;;
val nl : 'a list * int * int list = ([], 1, [2; 3; 4; 5])
# let nl = next nl ;;
val nl : int list * int * int list = ([1], 2, [3; 4; 5])
# let nl = next nl ;;
val nl : int list * int * int list = ([2; 1], 3, [4; 5])

# current nl ;;
- : int = 3
