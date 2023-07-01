let catalan : int ref = ref 0 in
Printf.printf "%d ," 1 ;
for i = 2 to 9  do
let nm : int ref = ref 1 in
let den : int ref = ref 1 in
for k = 2 to i do
nm := (!nm)*(i+k);
den := (!den)*k;
catalan := (!nm)/(!den) ;
done;
print_int (!catalan); print_string "," ;
done;;
