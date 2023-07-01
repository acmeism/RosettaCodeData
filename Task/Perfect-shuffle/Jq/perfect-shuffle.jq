def perfect_shuffle:
  . as $a
  | if (length % 2) == 1 then "cannot perform perfect shuffle on odd-length array" | error
    else (length / 2) as $mid
    | reduce range(0; $mid) as $i (null;
       .[2*$i] = $a[$i]
       | .[2*$i + 1] =  $a[$mid+$i] )
    end;

# How many iterations of f are required to get back to . ?
def recurrence(f):
  def r:
    # input: [$init, $current, $count]
    (.[1]|f) as $next
    | if .[0] == $next then .[-1] + 1
      else [.[0], $next, .[-1]+1] | r
      end;
   [., ., 0] | r;

def count_perfect_shuffles:
  [range(0;.)] | recurrence(perfect_shuffle);

(8, 24, 52, 100, 1020, 1024, 10000, 100000)
| [., count_perfect_shuffles]
