def factorial: reduce range(2;.+1) as $i (1; . * $i);

# Pick n items (with replacement) from the input array,
# but only consider distinct combinations:
def pick(n):
  def pick(n; m):  # pick n, from m onwards
    if n == 0 then []
    elif m == length then empty
    elif n == 1 then (.[m:][] | [.])
    else ([.[m]] + pick(n-1; m)), pick(n; m+1)
    end;
  pick(n;0) ;

# Given any array, produce an array of [item, count] pairs for each run.
def runs:
  reduce .[] as $item
    ( [];
      if . == [] then [ [ $item, 1] ]
      else  .[length-1] as $last
            | if $last[0] == $item then (.[0:length-1] + [ [$item, $last[1] + 1] ] )
              else . + [[$item, 1]]
              end
      end ) ;
