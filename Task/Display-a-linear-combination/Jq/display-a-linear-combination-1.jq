def linearCombo:
  reduce to_entries[] as {key: $k,value: $v} ("";
     if $v == 0 then .
     else
        (if $v < 0 and length==0 then   "-"
         elif $v < 0 then               " - "
         elif $v > 0 and length==0 then ""
         else                           " + "
         end) as $sign
        | ($v|fabs) as $av
        | (if ($av == 1) then "" else "\($av)*" end) as $coeff
        | .  + "\($sign)\($coeff)e\($k)"
     end)
  | if length==0 then "0" else . end ;

# The exercise
def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

[1, 2, 3],
[0, 1, 2, 3],
[1, 0, 3, 4],
[1, 2, 0],
[0, 0, 0],
[0],
[1, 1, 1],
[-1, -1, -1],
[-1, -2, 0, -3],
[-1]
| "\(lpad(15)) => \(linearCombo)"
