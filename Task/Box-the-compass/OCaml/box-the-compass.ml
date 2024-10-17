let test_cases = [0.0; 16.87; 16.88; 33.75; 50.62; 50.63; 67.5;
                  84.37; 84.38; 101.25; 118.12; 118.13; 135.0;
                  151.87; 151.88; 168.75; 185.62; 185.63; 202.5;
                  219.37; 219.38; 236.25; 253.12; 253.13; 270.0;
                  286.87; 286.88; 303.75; 320.62; 320.63; 337.5;
                  354.37; 354.38];;

let directions = ["North"; "North by East"; "North-Northeast";
                  "Northeast by North"; "Northeast";
                  "Northeast by East"; "East-Northeast"; "East by North";
                  "East"; "East by South"; "East-Southeast";
                  "Southeast by East"; "Southeast"; "Southeast by South";
                  "South-Southeast"; "South by East"; "South";
                  "South by West"; "South-Southwest"; "Southwest by South";
                  "Southwest"; "Southwest by West"; "West-Southwest";
                  "West by South"; "West"; "West by North";
                  "West-Northwest"; "Northwest by West"; "Northwest";
                  "Northwest by North"; "North-Northwest"; "North by West";];;

let get_direction_index input =
  let shifted = (input +. 5.6201) in
  let shifted = if shifted > 360. then shifted -. 360. else shifted in
  int_of_float (shifted /. 11.25);;

let print_direction input =
  let index = get_direction_index input in
  let direction = List.nth directions index in
  let test = Printf.printf "%3d %-20s %.2f\n" (index + 1) direction in
  test input;;

List.iter (print_direction) test_cases;;
