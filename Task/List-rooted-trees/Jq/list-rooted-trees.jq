# add one bag somewhere
def addbag:
  def sortmap: map(sortmap) | sort;
  if . == null then []             # one bag
  else ([[]] + .),
   (paths as $p
    | getpath($p) as $x
    | setpath($p; [[]] + $x)
    | sortmap                      # indistinguishability of bags
   )
  end ;

# emit a stream of the distinct rooted trees of order $n > 0
def rootedtrees($n):
  if $n==1 then []
  else foreach range(0; $n-1) as $i ([[]];
    [.[] | addbag] | unique;
    select($i == $n-2))
  | .[]
  end;

# emit $n arrays of the form [$i, $count] for 0 < $i <= $n
def count_rootedtrees($n):
  [1, 1],
  foreach range(0; $n - 1) as $i ([[]];
    [.[] | addbag] | unique;
    [$i + 2, length]) ;

rootedtrees(5),
"",
count_rootedtrees(17)
