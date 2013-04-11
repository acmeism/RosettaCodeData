@verb me:@tables none none none rxd
@program me:@tables
player:tell("    |      1    2    3    4    5    6    7    8    9   10   11   12");
player:tell("-------------------------------------------------------------------");
for i in [1..12]
  line = ((i < 10) ? "  " | " ") + tostr(i) + " |  ";
  for j in [1..12]
    if (j >= i)
      product = i * j;
      "calculate spacing for right justification of values";
      if (product >= 100)
        spacer = "";
      elseif (product >= 10)
        spacer = " ";
      else
        spacer = "  ";
      endif
      line = line + "  " + spacer + tostr(product);
    else
      line = line + "     ";
    endif
  endfor
  player:tell(line);
endfor
.
