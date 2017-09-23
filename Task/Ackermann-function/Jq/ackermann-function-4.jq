# input: [m,n, cache]
# output [value, updatedCache]
def ack:

  # input: [value,cache]; output: [value, updatedCache]
  def cache(key): .[1] += { (key): .[0] };

  def pow2: reduce range(0; .) as $i (1; .*2);

  .[0] as $m | .[1] as $n | .[2] as $cache
  | if   $m == 0 then [$n + 1, $cache]
    elif $m == 1 then [$n + 2, $cache]
    elif $m == 2 then [2 * $n + 3, $cache]
    elif $m == 3 then [8 * ($n|pow2) - 3, $cache]
    else
    (.[0:2]|tostring) as $key
    | $cache[$key] as $value
    | if $value then [$value, $cache]
      elif $n == 0 then
        ([$m-1, 1, $cache] | ack)
        | cache($key)
      else
        ([$m, $n-1, $cache ] | ack)
        | [$m-1, .[0], .[1]] | ack
        | cache($key)
      end
    end;

def A(m;n): [m,n,{}] | ack | .[0];
