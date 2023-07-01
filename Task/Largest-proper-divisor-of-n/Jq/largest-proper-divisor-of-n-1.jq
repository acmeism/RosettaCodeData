# (1|largestpd) is 1 as per the task definition
def largestpd:
  if . == 1 then 1
  else . as $n
  | first( range( ($n - ($n % 2)) /2; 0; -1) | (select($n % . == 0) ))
  end;
