reduce range(1;11) as $i
  (""; . + "\($i)" + (if $i % 5 == 0 then "\n" else ", " end))
