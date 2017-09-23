# The "while" loops are implemented using the following jq function:

# As soon as "condition" is true, then emit . and stop:
def do_until(condition; next):
  def u: if condition then . else (next|u) end;
  u;

# sort the input array
def shellSort:
  length as $length
  | [ ($length/2|floor), .]                          # L1: state: [h, array]
  | do_until( .[0] == 0;
              .[0] as $h
              | reduce range($h; $length) as $i      # L2: state: array
                  ( .[1];
                   .[$i] as $k
                   | [ $i, . ]                       # L3: state: [j, array]
                   | do_until( .[0] < $h or ($k >= .[1][.[0] - $h]);
                               .[0] as $j
                               | [ ($j - $h), (.[1]|setpath([$j]; .[$j - $h])) ] )
                   | .[0] as $j | (.[1]|setpath([$j]; $k))  # i.e. a[j] = $k
                  )
              | [(($h+1)*5/11 | floor), .] )
       | .[1] ;
