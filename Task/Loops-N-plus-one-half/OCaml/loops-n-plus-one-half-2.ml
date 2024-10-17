let ints = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10] in
let str_ints = List.map string_of_int ints in
print_endline (String.concat ", " str_ints);
