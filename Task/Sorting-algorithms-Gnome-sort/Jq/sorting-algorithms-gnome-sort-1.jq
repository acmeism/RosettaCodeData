# As soon as "condition" is true, then emit . and stop:
def do_until(condition; next):
  def u: if condition then . else (next|u) end;
  u;

# input: an array
def gnomeSort:
  def swap(i;j): .[i] as $x | .[i]=.[j] | .[j]=$x;

  length as $length
  # state: [i, j, ary]
  | [1, 2, .]
  | do_until( .[0] >= $length;
              .[0] as $i | .[1] as $j
              | .[2]
              # for descending sort, use >= for comparison
              | if .[$i-1] <= .[$i] then [$j, $j + 1, .]
                else swap( $i-1; $i)
                | ($i - 1) as $i
                | if $i == 0 then [$j, $j + 1, .]
                  else [$i, $j, .]
                  end
                end )
  | .[2];
