# select a row with the fewest number of unknowns
def next_row:
  length as $len
  | . as $in
  | reduce range(0;length) as $i ([];
        . + [ [ count( $in[$i][] | select(. != 0)), $i] ] )
  | map(select(.[0] != $len))
  | if length == 0 then null
    else max_by(.[0]) | .[1]
    end ;
