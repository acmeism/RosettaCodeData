def pascal(n):
  if n <= 0 then empty
  else [1]
  | recurse( if length >= n then empty
             else . as $in
             | reduce range(0;length-1) as $i
                 ([1]; . + [ $in[$i] + $in[$i + 1] ]) + [1]
             end)
  end;
