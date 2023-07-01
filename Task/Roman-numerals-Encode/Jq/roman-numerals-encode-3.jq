def digits: tostring | explode | map( [.]|implode|tonumber);
# Non-negative integer to Roman numeral up to 399,999
def to_roman_numeral:
  if . < 1 or . > 399999
  then "to_roman_numeral: \(.) is out of range" | error
  else [["I", "X", "C", "M", "ↂ", "\u2188"], ["V", "L", "D", "ↁ", "\u2187"]] as $DR
  | (digits|reverse) as $digits
  | reduce range(0;$digits|length) as $omag ({rnum: ""};
     $digits[$omag] as $d
     | if   $d == 0 then .omr = ""
       elif $d <  4 then .omr = $DR[0][$omag] * $d
       elif $d == 4 then .omr = $DR[0][$omag] + $DR[1][$omag]
       elif $d == 5 then .omr = $DR[1][$omag]
       elif $d <  9 then .omr = $DR[1][$omag] + ($DR[0][$omag] * ($d - 5))
       else .omr = $DR[0][$omag] + $DR[0][$omag+1]
       end
     | .rnum = .omr + .rnum )
  | .rnum
  end;
