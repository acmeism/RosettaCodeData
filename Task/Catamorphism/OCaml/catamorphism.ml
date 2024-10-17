# let nums = [1;2;3;4;5;6;7;8;9;10];;
val nums : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
# let sum = List.fold_left (+) 0 nums;;
val sum : int = 55
# let product = List.fold_left ( * ) 1 nums;;
val product : int = 3628800
