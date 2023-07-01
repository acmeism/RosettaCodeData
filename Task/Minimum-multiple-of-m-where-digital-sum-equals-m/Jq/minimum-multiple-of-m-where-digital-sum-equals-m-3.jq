# This function assumes that nan can be taken as the eos marker
def nwise(stream; $n):
  foreach (stream, nan) as $x ([];
    if length == $n then [$x] else . + [$x] end)
  | if (.[-1] | isnan) and length>1 then .[:-1]
    elif length == $n then .
    else empty
    end;
