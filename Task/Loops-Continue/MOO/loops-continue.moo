s = "";
for i in [1..10]
  s += tostr(i);
  if (i % 5 == 0)
    player:tell(s);
    s = "";
    continue;
  endif
  s += ", ";
endfor
