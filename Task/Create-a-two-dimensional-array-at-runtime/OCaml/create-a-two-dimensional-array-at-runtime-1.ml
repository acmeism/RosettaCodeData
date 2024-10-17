let nbr1 = read_int ();;
let nbr2 = read_int ();;
let array = Array.make_matrix nbr1 nbr2 0.0;;
array.(0).(0) <- 3.5;;
print_float array.(0).(0); print_newline ();;
