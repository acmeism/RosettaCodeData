  [0,1]
  | recurse( if .[0] == 15 then empty
             else .[1] as $c | (.[0] + 1) | [ ., (2 * (2*. - 1) * $c) / (. + 1) ]
             end )
