a = make(10, make(10));
for i in [1..10]
  for j in [1..10]
    a[i][j] = random(20);
  endfor
endfor
for i in [1..10]
  s = "";
  for j in [1..10]
    s += tostr(" ", a[i][j]);
    if (a[i][j] == 20)
      break i;
    endif
  endfor
  player:tell(s);
  s = "";
endfor
player:tell(s);
