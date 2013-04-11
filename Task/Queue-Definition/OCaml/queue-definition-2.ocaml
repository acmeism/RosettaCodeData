# open FIFO;;
# let q = empty ;;
val q : '_a FIFO.fifo = <abstr>
# is_empty q ;;
- : bool = true
# let q = push q 1 ;;
val q : int FIFO.fifo = <abstr>
# is_empty q ;;
- : bool = false

# let q =
    List.fold_left push q [2;3;4] ;;
val q : int FIFO.fifo = <abstr>

# let v, q = pop q ;;
val v : int = 1
val q : int FIFO.fifo = <abstr>
# let v, q = pop q ;;
val v : int = 2
val q : int FIFO.fifo = <abstr>
# let v, q = pop q ;;
val v : int = 3
val q : int FIFO.fifo = <abstr>
# let v, q = pop q ;;
val v : int = 4
val q : int FIFO.fifo = <abstr>
# let v, q = pop q ;;
Exception: Failure "empty fifo".
