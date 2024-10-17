# let range = mk_bounds 1 10 ;;
val range : int bounds = {min = 1; max = 10}

# let a = mk_bounded 2 range ;;
val a : int bounded = {value = 2; bounds = {min = 1; max = 10}}

# let b = mk_bounded 5 range ;;
val b : int bounded = {value = 5; bounds = {min = 1; max = 10}}

# let c = mk_bounded 14 range ;;
Exception: Out_of_bounds.

# op ( + ) a b ;;
- : int bounded = {value = 7; bounds = {min = 1; max = 10}}
