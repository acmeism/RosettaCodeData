# multiply two decimal strings, which may be signed (+ or -)
def long_multiply(num1; num2):

  def stripsign:
    .[0:1] as $a
    | if $a == "-" then [ -1, .[1:]]
    elif $a == "+" then [  1, .[1:]]
    else [1, .]
    end;

  def adjustsign(sign):
     if sign == 1 then . else "-" + . end;

  # mult/2 assumes neither argument has a sign
  def mult(num1;num2):
      (num1 | explode | map(.-48) | reverse) as $a1
    | (num2 | explode | map(.-48) | reverse) as $a2
    | reduce range(0; num1|length) as $i1
        ([];  # result
         reduce range(0; num2|length) as $i2
           (.;
            ($i1 + $i2) as $ix
            | ( $a1[$i1] * $a2[$i2] + (if $ix >= length then 0 else .[$ix] end) ) as $r
            | if $r > 9 # carrying
              then
                .[$ix + 1] = ($r / 10 | floor) +  (if $ix + 1 >= length then 0 else .[$ix + 1] end )
                | .[$ix] = $r - ( $r / 10 | floor ) * 10
              else
                .[$ix] = $r
              end
         )
        )
    | reverse | map(.+48) | implode;

  (num1|stripsign) as $a1
  | (num2|stripsign) as $a2
  | if $a1[1] == "0" or  $a2[1] == "0" then "0"
    elif $a1[1] == "1" then $a2[1]|adjustsign( $a1[0] * $a2[0] )
    elif $a2[1] == "1" then $a1[1]|adjustsign( $a1[0] * $a2[0] )
    else mult($a1[1]; $a2[1]) | adjustsign( $a1[0] * $a2[0] )
    end;
