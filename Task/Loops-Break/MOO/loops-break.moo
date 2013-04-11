while (1)
  a = random(20) - 1;
  player:tell(a);
  if (a == 10)
    break;
  endif
  b = random(20) - 1;
  player:tell(b);
endwhile
