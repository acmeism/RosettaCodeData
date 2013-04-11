@program me:@tables
player:tell("    |      1    2    3    4    5    6    7    8    9   10   11   12");
player:tell($string_utils:space(67, "-"));
for i in [1..12]
  line = " " + $string_utils:right(i, 2) + " |  ";
  for j in [1..12]
    line = line + "  " + ((i > j) ? "   " | $string_utils:right(j*i, 3));
  endfor
  player:tell(line);
endfor
.
