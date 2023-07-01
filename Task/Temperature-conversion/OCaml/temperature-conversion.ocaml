let print_temp s t =
  print_string s;
  print_endline (string_of_float t);;

let kelvin_to_celsius k =
  k -. 273.15;;

let kelvin_to_fahrenheit k =
  (kelvin_to_celsius k)*. 9./.5. +. 32.00;;

let kelvin_to_rankine k =
  (kelvin_to_celsius k)*. 9./.5. +. 491.67;;


print_endline "Enter a temperature in Kelvin please:";
let k = read_float () in
print_temp "K " k;
print_temp "C " (kelvin_to_celsius k);
print_temp "F " (kelvin_to_fahrenheit k);
print_temp "R " (kelvin_to_rankine k);;
