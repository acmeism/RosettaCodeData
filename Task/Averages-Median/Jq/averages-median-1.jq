def median:
  length as $length
  | sort as $s
  | if $length == 0 then null
    else ($length / 2 | floor) as $l2
      | if ($length % 2) == 0 then
          ($s[$l2 - 1] + $s[$l2]) / 2
        else $s[$l2]
        end
  end ;
