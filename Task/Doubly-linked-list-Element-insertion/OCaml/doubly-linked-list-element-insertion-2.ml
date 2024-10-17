# type t = A | B | C ;;
type t = A | B | C

# let dl = dlink_of_list [A; B] in
  insert dl C;
  list_of_dlink dl ;;
- : t list = [A; C; B]
