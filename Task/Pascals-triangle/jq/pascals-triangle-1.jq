# pascal(n) for n>=0; pascal(0) emits an empty stream.
def pascal(n):
  def _pascal:  # input: the previous row
    . as $in
    | .,
      if length >= n then empty
      else
        reduce range(0;length-1) as $i
          ([1]; . + [ $in[$i] + $in[$i + 1] ]) + [1] | _pascal
      end;
  if n <= 0 then empty else [1] | _pascal end ;
