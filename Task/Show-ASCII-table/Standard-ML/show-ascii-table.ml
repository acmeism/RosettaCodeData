fun Table  n 127 =  " 127: 'DEL'\n"
  | Table  0   x =  "\n" ^ (Table 10 x)
  | Table  n   x =  (StringCvt.padLeft #" " 4 (Int.toString x)) ^ ": '" ^ (str (chr x)) ^ "' " ^ ( Table (n-1) (x+1)) ;

print (Table 10 32) ;
