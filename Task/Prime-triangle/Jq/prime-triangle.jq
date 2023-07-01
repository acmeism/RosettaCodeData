# $i and $j should be relevant integers (possibly negataive)
# Usage with an array-valued key: .key |= array_swap($i; $j)
def array_swap($i; $j):
  if $i == $j then .
  else .[$i] as $t
  | .[$i] = .[$j]
  | .[$j] = $t
  end;

# For syntactic convenience
def swap($array; $i; $j):
  $array | array_swap($i; $j);

def pmap:
  reduce (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37) as $i ([];
    .[$i] = true)  ;

# input: {bFirst, arrang, canFollow, emit}
# output: same + {res, emit, i, count}
def ptrs($res; $n; $done):
  . + {$res, count: $done}
  | .arrang[$done-1] as $ad
  | if ($n - $done <= 1)
    then if .canFollow[$ad-1][$n-1]
         then if .bFirst
              then .emit += [.arrang]
              | .bFirst = false
              else .
              end
         | .res += 1
         else .
         end
    else .count += 1
    | .count as $count
    | reduce range($count - 1; $n - 1; 2) as $i (.;
        .arrang[$i] as $ai
        | if .canFollow[$ad-1][$ai-1]
          then .arrang = swap(.arrang; $i; $count-1)
          | ptrs(.res; $n; $count)
          | .arrang = swap(.arrang; $i; $count-1)
          else .
          end )
     end;

# Emit {emit, res} from the call to ptrs
def primeTriangle($n):
  pmap as $pmap
  | {}
  | .canFollow = (reduce range(0;$n) as $i ([];
        .[$i] = [range(0;$n) | false]
        | reduce range(0;$n) as $j (.;
            .[$i][$j] = $pmap[$i+$j+2] )))
  | .bFirst = true
  | .arrang = [range(1; 1+$n)]
  | ptrs(0; $n; 1)
  | {emit, res} ;

def task($n):
  range(2;$n+1) as $i
  |  primeTriangle($i) ;

def task($n):
  foreach (range(2;$n+1), null) as $i ({counts: [], emit: null};
    if $i == null then .emit = "\n\(.counts)"
    else primeTriangle($i) as $pt
    | .counts += [$pt|.res]
    | .emit = $pt.emit
    end;
    .emit);

task(20)[]
