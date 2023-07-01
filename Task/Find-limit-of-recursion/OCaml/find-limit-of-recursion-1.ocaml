# let last = ref 0 ;;
val last : int ref = {contents = 0}
# let rec f i =
    last := i;
    i + (f (i+1))
  ;;
val f : int -> int = <fun>
# f 0 ;;
stack overflow during evaluation (looping recursion?).
# !last ;;
- : int = 262067
