def runs:
  reduce .[] as $item
    ( [];
      if . == [] then [ [ $item, 1] ]
      else .[length-1] as $last
      | if $last[0] == $item then .[length-1] = [$item, $last[1] + 1]
        else . + [[$item, 1]]
        end
      end ) ;
