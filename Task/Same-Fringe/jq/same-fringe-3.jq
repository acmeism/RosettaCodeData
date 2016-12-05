  [1,[2,[3,[4,[5,[6,7]]]]]] as $a
  | [[[[[[1,2],3],4],5],6],7] as $b
  | [[[1,2],3],[4,[5,[6,7]]]] as $c
  | [[[1,2],2],4] as $d
  |  same_fringe($a;$a), same_fringe($b;$b), same_fringe($c;$c),
     same_fringe($a;$b), same_fringe($a;$c), same_fringe($b;$c),
     same_fringe($a;$d), same_fringe($d;$c), same_fringe($b;$d),

     same_fringe( ["a",["b",["c",[["x","y"],"z"]]]];
                  [[["a","b"],"c"],["x",["y","z"]]] )
