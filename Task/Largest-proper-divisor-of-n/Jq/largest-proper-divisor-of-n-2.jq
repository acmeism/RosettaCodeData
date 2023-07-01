def largestpd:
  if . == 1 then 1
  else . as $n
  | (first(2,3,5,7 | select($n % . == 0)) // null) as $div
  | if $div then $n/$div
    else first( range( ($n - ($n % 11)) /11; 0; -1) | (select($n % . == 0) ))
    end
  end;
