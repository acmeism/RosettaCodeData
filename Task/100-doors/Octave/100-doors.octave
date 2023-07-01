doors = false(100,1);
for i = 1:100
  for j = i:i:100
    doors(j) = !doors(j);
  endfor
endfor
for i = 1:100
  if ( doors(i) )
    s = "open";
  else
    s = "closed";
  endif
  printf("%d %s\n", i, s);
endfor
