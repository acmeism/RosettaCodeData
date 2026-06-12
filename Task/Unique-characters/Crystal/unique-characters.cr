p ["133252abcdeeffd",  "a6789798st",  "yxcdfgxcyz"].join.chars.tally
   .select {|_, count| count == 1}.keys.sort
