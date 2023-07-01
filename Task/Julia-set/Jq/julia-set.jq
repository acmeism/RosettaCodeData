# Example values:
# $re : -0.8
# $im : 0.156
{}
| range(-100; 101; 10) as $v
| (( range (-280; 281; 10) as $h
  | .x = $h / 200
  | .y = $v / 100
  | .plot = "#"
  | .i = 0
  | until (.i == 50 or .plot == ".";
           .i += 1
           | .z_real = ((.x * .x) - (.y * .y) + $re)
           | .z_imag = ((.x * .y * 2) + $im)
 	   | if pow(.z_real; 2) > 10000 then .plot = " "
             else .x = .z_real | .y = .z_imag
   	     end )
  | .plot ), "\n")
