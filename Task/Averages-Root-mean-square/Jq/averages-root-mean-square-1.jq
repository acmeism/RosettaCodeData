def rms: length as $length
  | if $length == 0 then null
    else map(. * .) | add | sqrt / $length
    end ;
