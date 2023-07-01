fun print_logic (a, b) = (
  print ("a and b is " ^ Bool.toString (a andalso b) ^ "\n");
  print ("a or b is " ^ Bool.toString (a orelse b) ^ "\n");
  print ("not a is " ^ Bool.toString (not a) ^ "\n")
)
