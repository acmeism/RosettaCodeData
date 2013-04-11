fun bottles 0 = ()
  | bottles x = ( print (Int.toString x ^ " bottles of beer on the wall\n");
                  print (Int.toString x ^ " bottles of beer\n");
                  print "Take one down, pass it around\n";
                  print (Int.toString (x-1) ^ " bottles of beer on the wall\n");
                  bottles (x-1)
                )
