open Creal;;

let block = 100 in
let segment n =
   let s = to_string pi (n*block) in
   String.sub s ((n-1)*block) block in
let counter = ref 1 in
while true do
   print_string (segment !counter);
   flush stdout;
   incr counter
done
