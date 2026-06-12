p ["1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"]
   .map {|s| s.chars.tally.select {|_, cnt| cnt == 1 }.keys }
   .reduce {|a, b| a & b }
   .sort
