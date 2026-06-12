def textbetween_strings($startdlm; $enddlm):
  explode
  | . as $in
  | (if $startdlm == "start" then 0 else ($startdlm | length) end) as $len
  | (if $startdlm == "start" then 0 else index($startdlm | explode) end) as $ix
  | if $ix
    then $in[$ix + $len:]
    | if $enddlm == "end" then .
      else index($enddlm | explode) as $ex
      | if $ex then .[:$ex] else . end
      end
    else []
    end
  | implode;
