for i in [1..5]
  s = "";
  for j in [1..i]
    s += "*";
  endfor
  player:tell(s);
endfor
