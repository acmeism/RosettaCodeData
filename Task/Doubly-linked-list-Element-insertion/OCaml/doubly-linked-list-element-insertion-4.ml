# type t = A | B | C ;;
type t = A | B | C

# let nl = nav_list_of_list [A; B] ;;
val nl : 'a list * t * t list = ([], A, [B])

# insert nl C ;;
- : 'a list * t * t list = ([], A, [C; B])
