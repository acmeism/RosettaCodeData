let a1 = [| 'a'; 'b'; 'c' |]
and a2 = [| 'A'; 'B'; 'C' |]
and a3 = [| '1'; '2'; '3' |] ;;

Array.iteri (fun i c1 ->
  print_char c1;
  print_char a2.(i);
  print_char a3.(i);
  print_newline()
) a1 ;;
