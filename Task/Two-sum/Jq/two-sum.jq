def twosum($s):
  . as $v
  | {i: 0, j: ($v|length - 1) }
  | until( .i >= .j  or  $v[.i] + $v[.j] == $s;
      if $v[.i] + $v[.j] < $s then .i += 1
      else .j -= 1
      end)
  | if .i >= .j then [] else [.[]] end ;  # as required

[0, 2, 11, 19, 90]
| (twosum(21), twosum(25))
