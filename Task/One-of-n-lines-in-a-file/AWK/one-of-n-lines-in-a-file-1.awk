#!/usr/bin/gawk -f
#
# Usage:
#   gawk -v Seed=$RANDOM -f one_of_n_lines_in_a_file.awk
#
BEGIN {
   srand(Seed ? Seed : 1);
}
{
   if (NR*rand() < 1 ) {
      line = $0
   }
}
END {
   print line;
}
