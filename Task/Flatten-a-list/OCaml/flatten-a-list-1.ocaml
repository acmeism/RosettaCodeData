# let flatten = List.concat ;;
val flatten : 'a list list -> 'a list = <fun>

# let li = [[1]; 2; [[3;4]; 5]; [[[]]]; [[[6]]]; 7; 8; []] ;;
                ^^^
Error: This expression has type int but is here used with type int list

# (* use another data which can be accepted by the type system *)
  flatten [[1]; [2; 3; 4]; []; [5; 6]; [7]; [8]] ;;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8]
