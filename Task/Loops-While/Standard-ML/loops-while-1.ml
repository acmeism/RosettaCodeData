val n = ref 1024;
while !n > 0 do (
  print (Int.toString (!n) ^ "\n");
  n := !n div 2
)
