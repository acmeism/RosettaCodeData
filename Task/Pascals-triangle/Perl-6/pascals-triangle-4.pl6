sub pascal ($n where $n >= 1) {
   say my @last = 1;
   for 1 .. $n - 1 -> $row {
       @last = 1, |map({ @last[$_] + @last[$_ + 1] }, 0 .. $row - 2), 1;
       say @last;
   }
}

pascal 10;
