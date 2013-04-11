sub pascal ($n where $n >= 1) {
   # Prints out $n rows of Pascal's triangle.
   say my @last = 1;
   for 1 .. $n - 1 -> $row {
       my @this = map { @last[$_] + @last[$_ + 1] }, 0 .. $row - 2;
       say @last = 1, @this, 1;
   }
}
