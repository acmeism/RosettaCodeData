is_open = make(100);
for pass in [1..100]
  for door in [pass..100]
    if (door % pass)
      continue;
    endif
    is_open[door] = !is_open[door];
  endfor
endfor

"output the result";
for door in [1..100]
  player:tell("door #", door, " is ", (is_open[door] ? "open" : "closed"), ".");
endfor
