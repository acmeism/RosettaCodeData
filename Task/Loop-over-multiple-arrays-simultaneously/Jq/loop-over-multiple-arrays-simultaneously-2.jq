# transpose a possibly jagged matrix
def transpose:
  if . == [] then []
  else (.[1:] | transpose) as $t
  | .[0] as $row
  | reduce range(0; [($t|length), (.[0]|length)] | max) as $i
         ([]; . + [ [ $row[$i] ] + $t[$i] ])
  end;
